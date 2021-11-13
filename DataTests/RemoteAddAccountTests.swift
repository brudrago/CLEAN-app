//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import XCTest

class RemoteAddAccount {
    
    private let url: URL
    private let httpClient: HttpClientProtocol
    
    init(url: URL, httpClient: HttpClientProtocol) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: url)
    }
}

protocol HttpClientProtocol {
    func post(url: URL)
}

class RemoteAddAccountTests: XCTestCase {

    func test_() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add()
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    class HttpClientSpy: HttpClientProtocol {
        
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}


