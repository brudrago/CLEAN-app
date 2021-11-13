//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import XCTest

class RemoteAddAccount {
    
    private let url: URL
    private let httpClient: HttpPostClientProtocol
    
    init(url: URL, httpClient: HttpPostClientProtocol) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: url)
    }
}

protocol HttpPostClientProtocol {
    func post(url: URL)
}

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add()
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    class HttpClientSpy: HttpPostClientProtocol {
        
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}


