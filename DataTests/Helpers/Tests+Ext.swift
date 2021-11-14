//
//  Tests+Ext.swift
//  DataTests
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation
import XCTest

extension XCTestCase {
    
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
}
