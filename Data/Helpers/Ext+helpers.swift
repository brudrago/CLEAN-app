//
//  Ext+helpers.swift
//  Data
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation

extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
