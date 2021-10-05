//
//  UserViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Combine
import Firebase

class UserViewModel: ObservableObject {
    @Published var userRepository = UserRepository()
    @Published var users = [User]()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        userRepository.$users
            .assign(to: \.users, on: self)
            .store(in: &subscriptions)
    }
    
    func addUser(name: String, balance: Int, key: String) {
        let newUser = User(name: name, balance: balance, key: key)
        userRepository.addUser(newUser)
    }
    
    func removeUser(_ id: String) {
        if let index = users.firstIndex(where: { $0.id == id }) {
            let user = users[index]
            userRepository.removeUser(user)
        }
    }
        
    func addToBalance(of id: String, by adjustment: Int) {
        if let index = users.firstIndex(where: { $0.id == id }) {
            var user = users[index]
            user.balance += adjustment
            userRepository.updateUser(user)
        } else {
            return
        }
    }
    
    func subtractFromBalance(of id: String, by adjustment: Int) {
        if let index = users.firstIndex(where: { $0.id == id }) {
            var user = users[index]
            user.balance -= adjustment
            userRepository.updateUser(user)
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
