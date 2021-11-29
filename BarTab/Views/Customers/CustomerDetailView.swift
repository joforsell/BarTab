//
//  CustomerDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-17.
//

import SwiftUI

struct CustomerDetailView: View {
    var customerVM: CustomerViewModel
    
    var body: some View {
        ForEach(customerVM.transactions) { transaction in
            TransactionView(transactionVM: transaction)
        }
    }
}

struct TransactionView: View {
    var transactionVM: TransactionViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(transactionVM.transaction.description)
                    .padding()
                Text("\(transactionVM.transaction.amount) kr")
            }
            Spacer()
            Text(transactionVM.formattedTimestamp)
        }
    }
}






struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailView(customerVM: CustomerViewModel(customer: Customer(name: "Johan", balance: 500, key: "TETEEE", email: "k.g@y.com")))
    }
}
