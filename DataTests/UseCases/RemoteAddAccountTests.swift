//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url() {
        let addAccountModel = makeAddAccountModel()
        let url = URL(string: "http://any-url.com")!
        let (sut,httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel:addAccountModel) { _ in} //passando o completion vazio pq nao precisamos dele nesse cenário de teste
        
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut,httpClientSpy) = makeSut()
        sut.add(addAccountModel: addAccountModel) { _ in}
        
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_fails() {
        let addAccountModel = makeAddAccountModel()
        let (sut,httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting") //usado em casos de testes assíncronos
        sut.add(addAccountModel: addAccountModel) { error in
            XCTAssertEqual(error, .unexpected)
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity) // O completion do SUT só irá ser chamado quando o completion do http devolver o erro
        wait(for: [exp], timeout: 1)
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

        var urls = [URL]() //Isso fara com que no teste seja checado o conteúdo de url e a quantidade, então se o método for chamado + de 1 vez, irá falhar
        var data: Data?
        var completion: ((HttpError) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            self.completion?(error)        }
    }
}

