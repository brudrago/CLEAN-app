//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import XCTest
import Domain

class RemoteAddAccount {
    
    private let url: URL
    private let httpClient: HttpPostClientProtocol
    
    init(url: URL, httpClient: HttpPostClientProtocol) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel) {
        httpClient.post(to: url, with: addAccountModel.toData())
    }
}

protocol HttpPostClientProtocol {
    func post(to url: URL, with data: Data?)
}

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url() {
        let addAccountModel = makeAddAccountModel()
        let url = URL(string: "http://any-url.com")!
        let (sut,httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel:addAccountModel)
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut,httpClientSpy) = makeSut()
        sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
}

extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount ,httpClienteSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut,httpClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
    }
   
    class HttpClientSpy: HttpPostClientProtocol {
        
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}

