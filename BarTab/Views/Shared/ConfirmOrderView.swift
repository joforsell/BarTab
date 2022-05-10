//
//  ConfirmOrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-02.
//

import SwiftUI
import SwiftUIX
import Introspect
import ToastUI
import GameController

struct ConfirmOrderView: View, Animatable {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    var drinkVM: DrinkViewModel
    var tappedDrink: String?
    
    @Binding var orderList: [DrinkViewModel]
    @Binding var orderMultiple: Bool
    
    @State var pct: CGFloat
    
    let onClose: () -> Void
    
    @State private var tagKey = ""
    @State private var isShowingPurchaseConfirmedToast = false
    @State private var currentCustomerName = ""
    @State private var textSize = CGSize(width: 200, height: 100)
    
    var body: some View {
        ZStack {
            if userHandler.user.usingTags {
                TextField("Scan your tag", text: $tagKey, onCommit: {
                    customerListVM.customerBoughtWithKey(drinkVM.drink, key: tagKey)
                    customerListVM.customerWithKey(tagKey) { result in
                        switch result {
                        case .failure(_):
                            currentCustomerName = "Unknown"
                        case .success(let customer):
                            currentCustomerName = customer.name
                        }
                    }
                    withAnimation {
                        isShowingPurchaseConfirmedToast = true
                    }
                })
                    .opacity(0)
            }
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name).font(.system(size: 80, weight: .black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Text(Currency.display(drinkVM.drink.price, with: userHandler.user)).font(.system(size: 60))
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(40)
            .padding(.top, 48)
            VStack {
                if userHandler.user.usingTags {
                    Image(systemName: "wave.3.right.circle.fill")
                        .font(.system(size: isPhone() ? 80 : 140))
                        .foregroundColor(.accentColor)
                        .padding()
                } else {
                    Menu {
                        ForEach(customerListVM.customerVMs) { customerVM in
                            Button("\(customerVM.customer.name)") {
                                customerListVM.customerBought(drinkVM.drink, customer: customerVM.customer)
                                if customerVM.customer.id != nil {
                                    TransactionListViewModel.addTransaction(makeTransaction(customer: customerVM.customer, drink: drinkVM.drink))
                                }
                                currentCustomerName = customerVM.customer.name
                                withAnimation {
                                    isShowingPurchaseConfirmedToast = true
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: isPhone() ? 80 : 140))
                            .foregroundColor(.accentColor)
                    }
                }
                Text(userHandler.user.usingTags ? LocalizedStringKey("Scan your tag to finalize your purchase.") : LocalizedStringKey("Select the bar guest making the purchase."))
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal)
                Button {
                    withAnimation {
                        orderMultiple = true
                        orderList.append(drinkVM)
                    }
                    onClose()
                } label: {
                    Image(systemName: "rectangle.stack.fill.badge.plus")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .opacity(0.8)
                        .padding()
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(40)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 1)) {
                                onClose()
                            }
                        }
                }
                Spacer()
            }
            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    Image(drinkVM.drink.image.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.2)
                        .foregroundColor(.accentColor.opacity(0.3))
                        .padding(20)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .toast(isPresented: $isShowingPurchaseConfirmedToast, dismissAfter: 3, onDismiss: {
            withAnimation {
                onClose()
            } }) {
                ToastView(systemImage: ("checkmark.circle.fill", .accentColor, 50), title: "Your purchase was finalized", subTitle: "\(currentCustomerName) bought \(confirmationVM.selectedDrink?.drink.name.lowercased() ?? "missing") for \(Currency.display(confirmationVM.selectedDrink?.drink.price ?? 0, with: userHandler.user)).")
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .introspectTextField { textField in
                if GCKeyboard.coalesced != nil {
                    textField.becomeFirstResponder()
                }
            }
    }
    
    private func makeTransaction(customer: Customer, drink: Drink) -> Transaction {
        let now = Date()
        return Transaction(name: drink.name, image: drink.image.rawValue, amount: (round(drink.price * 100) / 100.0), newBalance: (round((customer.balance - drink.price) * 100) / 100.0), date: now, customerID: customer.id!)
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
