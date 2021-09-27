//
//  UserStore.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

class UserStore: ObservableObject {
    @Published private var userList: UserList
    
    init(){
        userList = UserList(userList: [User(id: 0, name: "Johan Forsell", balance: 0, key: "ADW92NASD42")])
    }
    
    var users: [User] {
        userList.userList
    }
    
    func addUser(name: String, balance: Int, key: String) {
        userList.addUser(name: name, balance: balance, key: key)
    }
    
    func addToBalanceOf(_ id: Int) {
        userList.addToBalanceOf(id)
    }
    
    func subtractFromBalanceOf(_ id: Int) {
        userList.subtractFromBalanceOf(id)
    }
    
    func drinkBought(by key: String, for price: Int) {
        userList.drinkBought(by: key, for: price)
    }
}
