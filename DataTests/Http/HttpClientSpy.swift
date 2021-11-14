//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation
import Data

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
