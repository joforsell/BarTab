//
//  TransactionsListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-09.
//

import SwiftUI
import SwiftUIX

struct TransactionsListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var transactionListVM: TransactionListViewModel
    let customer: Customer?
    let onClose: () -> Void
    
    init(customer: Customer, onClose: @escaping () -> Void) {
        self.customer = customer
        self.onClose = onClose
        _transactionListVM = StateObject(wrappedValue: TransactionListViewModel(customer: customer))
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .padding()
                    .foregroundColor(.accentColor)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onClose()
                    }
                Spacer()
                Text(customer?.name ?? "Unknown")
                    .foregroundColor(.white)
                    .font(.callout)
                Spacer()
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding()
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    }
            }
            .frame(height: 50)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundColor(.white.opacity(0.3))
                .padding(.bottom, 0)
            ScrollView {
                ForEach(transactionListVM.transactions) { transaction in
                    TransactionRow(transactionVM: TransactionViewModel(transaction: transaction))
                }
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark).ignoresSafeArea())
    }
    
    struct TransactionRow: View {
        @StateObject var transactionVM: TransactionViewModel

        var body: some View {
            HStack {
                transactionVM.transactionImage!
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
                Text("$\(transactionVM.transaction.amount)")
                    .padding(.trailing)
                Text(transactionVM.transaction.name)
                Spacer()
                Text(transactionVM.transactionDate)
            }
            .padding()
            .foregroundColor(.white)
            .frame(height: 60, alignment: .leading)
            .cornerRadius(10)
        }
    }
}
