//
//  UserViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    init(){}
        
    func addUser(name: String, balance: Int, key: String) {
        let newUser = User(name: name, balance: balance, key: key, drinksBought: [])
        users.append(newUser)
    }
    
    func removeUserBy(id: String) {
        users.removeAll(where: { $0.id == id })
    }
    
    func addToBalanceOf(_ id: String) {
        if let index = users.firstIndex(where: { $0.id == id }) {
            users[index].balance += 10
        } else {
            return
        }
    }
    
    func subtractFromBalanceOf(_ id: String) {
        if let index = users.firstIndex(where: { $0.id == id }) {
            users[index].balance -= 10
        } else {
            return
        }
    }
    
    func drinkBought(by key: String, for price: Int) {
        if let index = users.firstIndex(where: { $0.key == key }) {
            users[index].balance -= price
        } else {
            return
        }
    }
}
