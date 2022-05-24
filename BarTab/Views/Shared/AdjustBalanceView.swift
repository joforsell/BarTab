//
//  AdjustBalanceView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-20.
//

import SwiftUI
import SwiftUIX
import ToastUI

struct AdjustBalanceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    
    init(customer: Customer, currentBalance: Int, showingAdjustmentView: Binding<Bool>) {
        self.customer = customer
        self.currentBalance = currentBalance
        self._showingAdjustmentView = showingAdjustmentView
        UITextView.appearance().backgroundColor = .clear
    }
    
    let customer: Customer
    let currentBalance: Int
    var stringedBalance: String {
        let adjustedBalance = Float(currentBalance) / 100
        return Currency.display(adjustedBalance, with: userHandler.user)
    }
    
    @FocusState private var isMessageFocused: Bool
    
    @Binding var showingAdjustmentView: Bool
    @State var message = ""
    @State var adding = true
    @State var balanceAdjustment = ""
    @State var showingNumpad = false
    @State var showingToast = false
    
    let columnWidth: CGFloat = 300
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Adjust balance")
                    .font(.largeTitle, weight: .bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 48)
                    .padding(.bottom, 24)
                HStack {
                    Text(customer.name)
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal, 44)
                HStack {
                    Text(stringedBalance)
                        .font(.title3, weight: .light)
                    Spacer()
                }
                .padding(.horizontal, 44)
                
                HStack {
                    if !adding {
                        Text("-")
                            .font(.largeTitle, weight: .black)
                    }
                    Text(Currency.displayDecimalAgnostic((Float(balanceAdjustment) ?? 0) * 100, with: userHandler.user))
                        .font(.largeTitle, weight: .black)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
                .background(VisualEffectBlurView(blurStyle: .dark).opacity(0.4))
                .addBorder(adding ? Color.lead : Color.deficit, width: 2, cornerRadius: 10)
                .padding()
                .animation(.easeInOut, value: adding)
                .onTapGesture {
                    withAnimation {
                        showingNumpad.toggle()
                    }
                }
                
                addOrSubtractButtons
                messageBox
                Spacer()
                actionButtons
            }
        }
        .overlay(alignment: .bottom) {
            if showingNumpad {
                NumPadView(balanceAdjustment: $balanceAdjustment, showingNumpad: $showingNumpad)
                    .frame(height: min(400, UIScreen.main.bounds.height / 2))
                    .transition(.move(edge: .bottom))
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
        .toast(isPresented: $showingToast, dismissAfter: 3, onDismiss: {
            withAnimation {
                if adding {
                    customerListVM.addToBalance(of: customer, by: Int((Float(balanceAdjustment) ?? 0) * 100), with: message)
                } else {
                    customerListVM.subtractFromBalance(of: customer, by: Int((Float(balanceAdjustment) ?? 0) * 100), with: message)
                }
                showingToast = false
                showingAdjustmentView = false
            }
        }) {
            ToastView(systemImage: ("dollarsign.circle.fill", .accentColor, 50), title: "Adjustment successfully made", subTitle: LocalizedStringKey("\(addedOrSubtracted) \(balanceAdjustment) \(toOrFrom) the balance of \(customer.name)."))
        }
    }
    
    private var addOrSubtractButtons: some View {
        HStack {
            Button {
                adding = true
            } label: {
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.title2, weight: .bold)
                        .frame(width: 20, height: 20)
                    Text("Add")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .fixedSize()
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.lead).opacity(adding ? 0.8 : 0.2)
                .addBorder(Color.lead.opacity(adding ? 1 : 0.5), width: adding ? 2 : 0, cornerRadius: 10)
            }
            Button {
                adding = false
            } label: {
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "minus")
                        .font(.title2, weight: .bold)
                        .frame(width: 20, height: 20)
                    Text("Subtract")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .fixedSize()
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.deficit).opacity(!adding ? 0.8 : 0.2)
                .addBorder(Color.deficit.opacity(!adding ? 1 : 0.5), width: !adding ? 2 : 0, cornerRadius: 10)
            }
        }
        .frame(width: columnWidth)
    }
    
    private var toOrFrom: String {
        if adding {
            return String(format: NSLocalizedString("to", comment: ""))
        } else {
            return String(format: NSLocalizedString("from", comment: ""))
        }
    }
    
    private var addedOrSubtracted: String {
        if adding {
            return String(format: NSLocalizedString("Added", comment: ""))
        } else {
            return String(format: NSLocalizedString("Subtracted", comment: ""))
        }
    }
    
    private var messageBox: some View {
        TextEditor(text: $message)
            .focused($isMessageFocused)
            .frame(width: columnWidth, height: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(6)
            .addBorder(isMessageFocused ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
            .animation(.easeInOut, value: isMessageFocused)
            .autocapitalization(.sentences)
            .disableAutocorrection(true)
            .onChange(of: isMessageFocused, perform: { focus in
                if focus {
                    self.avoider.editingField = 1
                }
            })
            .avoidKeyboard(tag: 1)
            .overlay(alignment: .topTrailing) {
                Button {
                    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Image(systemName: isMessageFocused ? "checkmark.rectangle.fill" : "text.quote")
                        .resizable()
                        .scaledToFit()
                        .opacity(isMessageFocused ? 1 : 0.5)
                        .frame(height: 30)
                        .foregroundColor(isMessageFocused ? .accentColor : .white)
                        .animation(.easeInOut, value: isMessageFocused)
                }
                .offset(x: -18, y: 12)
            }
            .overlay(alignment: .topLeading) {
                Text("Note")
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .offset(x: 16, y: 8)
            }
            .padding(.vertical, 48)
    }
    
    private var actionButtons: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
            Spacer()
            Button {
                showingToast = true
            } label: {
                Image(systemName: "checkmark")
                    .font(.largeTitle, weight: .bold)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 44)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding(.bottom, 48)
    }
}
