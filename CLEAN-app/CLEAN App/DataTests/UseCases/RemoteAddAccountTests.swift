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
        sut.add(addAccountModel: makeAddAccountModel()) { _ in}
        XCTAssertEqual(httpClientSpy.url, url)
        XCTAssertEqual(httpClientSpy.callsCount, 1)
    }
    func test_add_should_call_httpClient_with_correct_data(){
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: URL(string: "www.google.com")!, httpClient: httpClientSpy)
        let addAccountModelMock = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModelMock) { _ in}
        XCTAssertEqual(httpClientSpy.data, addAccountModelMock.toData())
    }
    
    func test_add_should_complete_with_error_if_client_fails(){
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: URL(string: "www.google.com")!, httpClient: httpClientSpy)
        //necessário pra quando testar func assincrona
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { error in
            XCTAssertEqual(error, .unexpected)
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
      wait(for: [exp], timeout: 1)
    }
}

extension RemoteAddAccountTests {
    
    func makeAddAccountModel()->AddAccountModel {
        return AddAccountModel(name: "any-name", email: "any-email@email.com", password: "any-password", passwordConfirmation: "any-password")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data : Data?
        var callsCount = 0
        var completion: ((HttpError)-> Void)?
        
        func post(to url: URL, with data: Data?,completion: @escaping (HttpError)-> Void ) {
            self.url = url
            self.data = data
            self.completion = completion
            callsCount += 1
        }
        
        func completeWithError(_ error: HttpError){
            completion?(error)
        }
    }
}
