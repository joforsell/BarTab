//
//  TransactionViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-09.
//

import Foundation
import SwiftUI
import Combine

class TransactionViewModel: ObservableObject {
    @Environment(\.locale) var locale

    @Published var transactionImage: Image?
    @Published var transactionDate = ""
    @Published var transactionTime = ""
    @Published var transaction: Transaction
    
    private var cancellables = Set<AnyCancellable>()
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        $transaction
            .map { transaction in
                if transaction.image == "openingBalance" {
                    return Image(systemName: "rectangle.portrait.and.arrow.right")
                } else if transaction.image == "addedBalance" {
                    return Image(systemName: "plus.square")
                } else if transaction.image == "removedBalance" {
                    return Image(systemName: "minus.square")
                } else {
                    return Image(transaction.image)
                }
            }
            .assign(to: \.transactionImage, on: self)
            .store(in: &cancellables)
        
        $transaction
            .map { transaction in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter.string(from: transaction.date)
            }
            .assign(to: \.transactionDate, on: self)
            .store(in: &cancellables)
        
        $transaction
            .map { transaction in
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                formatter.locale = self.locale
                return formatter.string(from: transaction.date)
            }
            .assign(to: \.transactionTime, on: self)
            .store(in: &cancellables)
    }
}
