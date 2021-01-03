//
//  HttpPostClient.swift
//  Data
//
//  Created by Bruna Fernanda Drago on 03/01/21.
//
import Foundation

public protocol HttpPostClient {
    func post(to url:URL, with data:Data?)
}
