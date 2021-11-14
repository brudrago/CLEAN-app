//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Bruna Fernanda Drago on 14/11/21.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    
    func post(to url: URL) {
        
    }
}

class AlamofireAdapterTests: XCTestCase {

    func test_() {
        let url = makeUrl()
        let sut = AlamofireAdapter()
        sut.post(to: url)
    }
}
