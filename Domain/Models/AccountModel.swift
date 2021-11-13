//
//  AccountModel.swift
//  Domain
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation

public struct AccountModel: Model {
   public var id: String
   public var name: String
   public var email: String
   public var password: String
    
    public init(id: String, name: String,email: String,password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
