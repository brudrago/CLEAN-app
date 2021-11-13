//
//  Model.swift
//  Domain
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation

public protocol Model: Encodable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
