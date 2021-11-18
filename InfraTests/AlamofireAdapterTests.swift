//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Bruna Fernanda Drago on 14/11/21.
//

import XCTest
import Alamofire

class UrlProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest)-> Void)?
    
    static func observeRequest(completion: @escaping (URLRequest)-> Void) {
        UrlProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }
    
    override open func stopLoading() {}
        
}

class AlamofireAdapter {
    private var session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL) {
        session.request(url, method: .post).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {
    //testando se o alamofire esta sendo chamado com a url correta e utilizando o método post
    func test_() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
