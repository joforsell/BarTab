//
//  UserList.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import Foundation

struct UserList: Codable {
    var userList: [User]
    
    var uniqueUserId = 0
    
    mutating func addUser(name: String, balance: Int, key: String) {
        uniqueUserId += 1
        let newUser = User(id: uniqueUserId, name: name, balance: balance, key: key)
        userList.append(newUser)
    }
    
    mutating func removeUserBy(id: Int) {
        userList.removeAll(where: { $0.id == id })
    }
    
    mutating func addToBalanceOf(_ id: Int) {
        if let index = userList.firstIndex(where: { $0.id == id }) {
            userList[index].balance += 10
        } else {
            return
        }
    }
    
    mutating func subtractFromBalanceOf(_ id: Int) {
        if let index = userList.firstIndex(where: { $0.id == id }) {
            userList[index].balance -= 10
        } else {
            return
        }
    }
    
    mutating func drinkBought(by key: String, for price: Int) {
        if let index = userList.firstIndex(where: { $0.key == key }) {
            userList[index].balance -= price
        } else {
            return
        }
    }
}

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var balance: Int
    var key: String
}
