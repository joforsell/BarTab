//
//  NumberPadViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-09.
//

import Foundation

class NumberPadViewModel: ObservableObject {
    @Published var amount: String = "0"
    @Published var adding: Bool = true
    
    let buttons = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["back", "0", "enter"]
    ]
    
    func addNumValue(of number: String) {
        if amount.count < 7 {
            if amount == "0" {
                amount.removeLast()
                amount.append(number)
            } else {
                amount.append(number)
            }
        }
    }
    
    func eraseNum() {
        if amount.count > 1 {
            amount.removeLast()
        } else {
            amount = "0"
        }
    }
}
