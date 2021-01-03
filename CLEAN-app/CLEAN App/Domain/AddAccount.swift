//
//  AddAccount.swift
//  Domain
//
//  Created by Bruna Fernanda Drago on 02/01/21.
//

import Foundation

public protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result < AccountModel,Error>)->Void)
}

public struct AddAccountModel:Encodable {
    public   var name                : String
    public   var email               : String
    public   var password            : String
    public   var passwordConfirmation: String
    
    //a struct já vem com um init ,porém como a tornei public para que pudesse acesá-la por outro target, ela perde seu init e é necessário adicionar outro
    public init(name:String,email:String,password:String,passwordConfirmation:String){
          self.name = name
          self.email = email
          self.password = password
          self.passwordConfirmation = passwordConfirmation
        
    }
}

