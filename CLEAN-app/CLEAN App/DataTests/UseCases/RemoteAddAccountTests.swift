//
//  DataTests.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 02/01/21.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url(){
        let url = URL(string: "www.google.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add(addAccountModel: makeAddAccountModel())
        XCTAssertEqual(httpClientSpy.url, url)
    }
    func test_add_should_call_httpClient_with_correct_data(){
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: URL(string: "www.google.com")!, httpClient: httpClientSpy)
        let addAccountModelMock = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModelMock)
        XCTAssertEqual(httpClientSpy.data, addAccountModelMock.toData())
    }
}

extension RemoteAddAccountTests {
    
    func makeAddAccountModel()->AddAccountModel {
        return AddAccountModel(name: "any-name", email: "any-email@email.com", password: "any-password", passwordConfirmation: "any-password")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data : Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
