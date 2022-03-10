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
    @Published var transaction: Transaction
    
    private var cancellables = Set<AnyCancellable>()
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        $transaction
            .map { transaction in
                if transaction.image == "openingBalance" {
                    return Image(systemName: "star")
                } else if transaction.image == "addedBalance" {
                    return Image(systemName: "plus.circle")
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
                formatter.locale = Locale(identifier: self.locale.identifier)
                return formatter.string(from: transaction.date)
            }
            .assign(to: \.transactionDate, on: self)
            .store(in: &cancellables)
    }
}
