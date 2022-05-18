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
    @Binding var customer: Customer
    let onClose: () -> Void
    
    init(customer: Binding<Customer>, onClose: @escaping () -> Void) {
        _customer = customer
        self.onClose = onClose
        _transactionListVM = StateObject(wrappedValue: TransactionListViewModel(customer: customer.wrappedValue))
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
                Text(customer.name)
                    .foregroundColor(.white)
                    .font(.title3)
                Spacer()
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 50, height: 50)
                    .background {
                        CacheableAsyncImage(url: $customer.profilePictureUrl, animation: .easeIn, transition: .opacity) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    }
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxHeight: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                            case .failure( _):
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(0.6)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    .padding(.trailing, 16)
            }
            .frame(height: 50)
            .padding(.top, 8)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundColor(.white.opacity(0.3))
                .padding(.bottom, 0)
            ScrollView {
                ForEach(transactionListVM.transactions.sorted { $0.transactionNumber ?? 0 > $1.transactionNumber ?? 0 }) { transaction in
                    HStack {
                        Rectangle()
                            .frame(width: 4)
                            .foregroundColor(barColor(for: transaction.name))
                        VStack {
                            TransactionRow(transactionVM: TransactionViewModel(transaction: transaction))
                            Divider()
                        }
                    }
                }
            }
            .padding(.bottom, 48)
        }
        .background(VisualEffectBlurView(blurStyle: .dark).ignoresSafeArea())
    }
    
    struct TransactionRow: View {
        @EnvironmentObject var userHandler: UserHandling

        @StateObject var transactionVM: TransactionViewModel

        var body: some View {
            HStack {
                transactionImage
                nameAndPrice
                timeForTransaction
            }
            .padding(.trailing)
            .foregroundColor(.white)
            .frame(height: 60, alignment: .leading)
            .cornerRadius(10)
        }
        
        var transactionImage: some View {
            VStack(alignment: .center) {
                transactionVM.transactionImage!
                    .resizable()
                    .scaledToFit()
                    .maxHeight(38)
                    .foregroundColor(.accentColor)
            }
            .frame(width: 30)
            .padding(8)
        }
        
        var nameAndPrice: some View {
            VStack(alignment: .leading) {
                Text(transactionVM.transaction.name)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                HStack {
                    Text(addOrRemove(transactionVM.transaction))
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Text(Currency.display(Float(transactionVM.transaction.newBalance), with: userHandler.user))
                        .opacity(0.5)
                        .padding(.trailing, 4)
                }
            }
        }
        
        var timeForTransaction: some View {
            VStack {
                Spacer()
                Text(transactionVM.transactionDate)
                    .padding(.bottom, 0)
                Text(transactionVM.transactionTime)
                Spacer()
            }
            .font(.caption2)
        }
        
        private func addOrRemove(_ transaction: Transaction) -> String {
            if transaction.name != "Opening balance" && transaction.name != "Added to balance" {
                return Currency.remove(Float(transactionVM.transaction.amount), with: userHandler.user)
            } else {
                return Currency.add(Float(transactionVM.transaction.amount), with: userHandler.user)
            }
        }
    }
    
    private func barColor(for transaction: String) -> Color {
        if transaction == "Opening balance" || transaction == "Added to balance" {
            return Color("Lead")
        } else {
            return Color("Deficit")
        }
    }
}
