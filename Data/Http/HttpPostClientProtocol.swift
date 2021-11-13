//
//  HttpPostClientProtocol.swift
//  Data
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation

public protocol HttpPostClientProtocol {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data,HttpError>)-> Void)
}
