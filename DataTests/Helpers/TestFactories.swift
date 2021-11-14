//
//  Testfactories.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}
