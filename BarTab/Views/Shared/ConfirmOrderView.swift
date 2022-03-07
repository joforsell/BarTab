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

struct ConfirmOrderView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    var drinkVM: DrinkViewModel
    @Binding var tappedDrink: String?
    
    @State private var tagKey = ""
    @State private var isShowingPurchaseConfirmedToast = false
    @State private var currentCustomerName = ""
    @State private var textSize = CGSize(width: 200, height: 100)
    
    var body: some View {
        if userHandler.user.usingTags {
            orderWithTagView
        } else {
            orderWithoutTagView
        }
    }
    
    var orderWithTagView: some View {
        ZStack {
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
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name)
                    .font(.system(size: 80, weight: .black))
                    .fixedSize()
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal)
                Text("$\(drinkVM.drink.price)")
                    .font(.system(size: 60))
                    .fixedSize()
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(40)
            VStack {
                Image(systemName: "wave.3.right.circle.fill")
                    .font(.system(size: 140))
                    .foregroundColor(.accentColor)
                    .padding()
                Text("Scan your tag to finalize your purchase.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fixedSize()
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal)
            }
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(40)
                        .onTapGesture {
                            withAnimation {
                                tappedDrink = nil
                            }
                        }
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Menu {
                        ForEach(customerListVM.customerVMs) { customerVM in
                            Button("\(customerVM.customer.name)") {
                                customerListVM.customerBought(drinkVM.drink, customer: customerVM.customer)
                                currentCustomerName = customerVM.customer.name
                                withAnimation {
                                    isShowingPurchaseConfirmedToast = true
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .padding(40)
                    Spacer()
                }
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
        .toast(isPresented: $isShowingPurchaseConfirmedToast, dismissAfter: 3, onDismiss: {
            withAnimation {
                tappedDrink = nil
            } }) {
                ToastView(systemImage: ("checkmark.circle.fill", .accentColor, 50), title: "Your purchase was finalized", subTitle: "\(currentCustomerName) bought \(confirmationVM.selectedDrink?.drink.name.lowercased() ?? "missing") with $\(confirmationVM.selectedDrink?.drink.price ?? 0).")
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .introspectTextField { textField in
                if GCKeyboard.coalesced != nil {
                    textField.becomeFirstResponder()
                }
            }
    }
    
    var orderWithoutTagView: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name).font(.system(size: 80, weight: .black))
                    .fixedSize()
                    .padding(.horizontal)
                    .background(
                        GeometryReader { geo -> Color in
                            DispatchQueue.main.async {  // hack for modifying state during view rendering.
                                textSize = geo.size
                            }
                            return Color.clear
                        }
                    )
                Text("$\(drinkVM.drink.price)").font(.system(size: 60))
                    .fixedSize()
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(40)
            VStack {
                Menu {
                    ForEach(customerListVM.customerVMs) { customerVM in
                        Button("\(customerVM.customer.name)") {
                            customerListVM.customerBought(drinkVM.drink, customer: customerVM.customer)
                            currentCustomerName = customerVM.customer.name
                            withAnimation {
                                isShowingPurchaseConfirmedToast = true
                            }
                        }
                    }
                } label: {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 140))
                        .foregroundColor(.accentColor)
                }
                Text("Choose the bar guest making the purchase.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fixedSize()
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal)
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
                                tappedDrink = nil
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
        .toast(isPresented: $isShowingPurchaseConfirmedToast, dismissAfter: 3, onDismiss: {
            withAnimation {
                tappedDrink = nil
            } }) {
                ToastView(systemImage: ("checkmark.circle.fill", .accentColor, 50), title: "Your purchase was finalized", subTitle: "\(currentCustomerName) bought \(confirmationVM.selectedDrink?.drink.name.lowercased() ?? "missing") with $\(confirmationVM.selectedDrink?.drink.price ?? 0).")
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
    }
}
