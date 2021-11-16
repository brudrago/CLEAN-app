//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Bruna Fernanda Drago on 14/11/21.
//

import XCTest
import Alamofire

class UrlProtocolStub: URLProtocol {
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        
    }
    
    override open func stopLoading() {}
        
}

class AlamofireAdapter {
    private var session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL) {
        
    }
}

class AlamofireAdapterTests: XCTestCase {

    func test_() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
    }
}
