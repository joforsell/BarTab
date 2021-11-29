//
//  TransactionViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-27.
//

import Foundation
import Combine

class TransactionViewModel: ObservableObject, Identifiable {
    @Published var transaction: Transaction
    
    var formattedTimestamp = ""
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        $transaction
            .compactMap { transaction in
                transaction.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $transaction
            .sink { transaction in
                let formatter = DateFormatter()
                formatter.dateFormat = "YY/MM/dd"
                let formattedDate = formatter.string(from: transaction.createdTime)
                self.formattedTimestamp = formattedDate
            }
            .store(in: &cancellables)
    }
}
