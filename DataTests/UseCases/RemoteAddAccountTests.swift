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
        let url = makeUrl()
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
    
    func test_add_should_complete_with_error_if_client_completes_with_error() {
        let addAccountModel = makeAddAccountModel()
        let (sut,httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting") //usado em casos de testes assíncronos
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity) // O completion do SUT só irá ser chamado quando o completion do http devolver o erro
        wait(for: [exp], timeout: 1)
    }
    //Deixei o corpo de teste diferente pra mostrar as possibilidades, pode montar com várias linhas ou usar o expect/Helper p/nao repetir código
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() {
        let expectedAccount = makeAccountModel()
        let (sut,httpClientSpy) = makeSut()
        expect(sut, completeWith: .success(expectedAccount), when: {
            httpClientSpy.completeWithData(expectedAccount.toData()!)
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() { //testa se o JSOn vier com falha
        let (sut,httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func test_add_should_not_complete_if_sut_has_been_deallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeUrl(), httpClient: httpClientSpy)
        var result: Result<AccountModel,DomainError>?
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0}
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}


extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!,file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount ,httpClienteSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeaks(for: sut)
        checkMemoryLeaks(for: httpClientSpy)
        return (sut,httpClientSpy)
    }
    
    /// Testar Memory Leaks: - addTeardownBlock é executado depois de cada teste e antes do teardown ser chamado, fazendo assertNil na classe que estamos testando, verificamos se em algum momento temos memory leaks
    /// - Parameters:
    ///   - instance: SUT, classe que estamos testando
    ///   - file: Aponta qual teste falhou
    ///   - line: Aponta a linha em que o teste falhou
    func checkMemoryLeaks(for instance: AnyObject,file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,file: file, line: line)
        }
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) { // file: file, line: line -> pra mostrar o erro quando o teste falhar na linha do teste e nao no switch
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount,  file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
          action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeInvalidData() -> Data {
        return Data("invalid_data".utf8)
    }
    
    func makeUrl() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "any_id", name: "any_name", email: "any_email@mail.com", password: "any_password")
    }
    
    class HttpClientSpy: HttpPostClientProtocol {
        
        var urls = [URL]() //Isso fara com que no teste seja checado o conteúdo de url e a quantidade, então se o método for chamado + de 1 vez, irá falhar
        var data: Data?
        var completion: ((Result<Data,HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data,HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}

