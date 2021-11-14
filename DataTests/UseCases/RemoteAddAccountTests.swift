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

// MARK: - RemoteAddAccountTests Extension <HELPERS>

extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!,file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount ,httpClienteSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeaks(for: sut)
        checkMemoryLeaks(for: httpClientSpy)
        return (sut,httpClientSpy)
    }
    
    /// Essa func implementa os passos necessários para construir os dados utilizados na maior parte dos cenários de teste.
    /// - Parameters:
    ///   - sut: Classe sendo testada
    ///   - expectedResult: Resultado esperado
    ///   - action: Quando deve executar
    ///   - file: Mostra o teste que falhou -> pra mostrar o erro quando o teste falhar na linha do teste e nao no switch
    ///   - line: Mostra a linha em que o teste falhou
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
    }
}

