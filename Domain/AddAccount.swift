//
//  AddAccount.swift
//  Domain
//
//  Created by Bruna Fernanda Drago on 13/11/21.
//

import Foundation

protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>)-> Void)
}

struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}
