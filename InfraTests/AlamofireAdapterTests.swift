//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Bruna Fernanda Drago on 14/11/21.
//

import XCTest
import Alamofire

//Não depende de nenhum framwork , vamos interceptar as chamadas
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
    
    func post(to url: URL, with data: Data?) {
        let json = data == nil ? nil : try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
        session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {
    //testando se o alamofire esta sendo chamado com a url correta e utilizando o método post
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        let sut = makeSut()
        sut.post(to: url, with: makeValidData())
        let exp = expectation(description: "waiting")
        //precisamos fazer esse observe pq o teste é assíncrono,e como nao estamos injetando o stub como uma dependencia do Adapter,precisamos capturar o valor que queremos testar
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_post_should_make_request_with_no_data() {
        let url = makeUrl()
        let sut = makeSut()
        sut.post(to: url, with: nil)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertNil(request.httpBodyStream)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension AlamofireAdapterTests {
    
    func makeSut() -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        return AlamofireAdapter(session: session)
    }
}
