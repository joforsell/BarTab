//
//  BalanceUpdateEmailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-19.
//

import SwiftUI
import SwiftUIX
import ToastUI

struct BalanceUpdateEmailView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    @Binding var presenting: Bool
    
    @FocusState private var isMessageFocused: Bool
    
    @State var showingPreview = false
    @State var message = ""
    @State private var foobar = false
    @State private var showingCustomers = false
    @State private var showError = false
    @State private var errorPrompt: ErrorPrompt?
    @State private var isShowingEmailConfirmation = false


    var mailingListAmount: Int {
        return customerListVM.customerVMs.filter { $0.checked == true }.count
    }
    
    let columnWidth: CGFloat = 300
    let rowItemHeight: CGFloat = 40
    
    init(presenting: Binding<Bool>) {
        self._presenting = presenting
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Text("Balance update")
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                        previewButton
                    }
                    KeyboardAvoiding(with: avoider) {
                        messageBox
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Check bar guests with:")
                            VStack(alignment: .leading) {
                                allButton
                                negativeBalanceButton
                                positiveBalanceButton
                            }
                        }
                        .frame(width: columnWidth)
                        .padding(.top, 24)
                        Spacer()
                    }

                    VStack(alignment: .center) {
                        sendListHeader
                        sendList
                        remainingListHeader
                        if showingCustomers {
                            remainingList
                        }
                    }
                    actionButtons
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlurEffectView(style: .dark).ignoresSafeArea())
            .overlay(showingPreview ?
                     EmailPreviewView(showingPreview: $showingPreview,
                                      message: $message,
                                      previewCustomer: customerListVM.customerVMs.first(where: { $0.checked == true })?.customer)
                        .ignoresSafeArea()
                        .overlay(alignment: .topTrailing) {
                            Button {
                                showingPreview.toggle()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.accentColor)
                                    .shadow(radius: 2)
                                    .padding()
                            }
                        }
                     : nil)
    }
    
    private var previewButton: some View  {
        Button {
            showingPreview.toggle()
        } label: {
            VStack {
                Image(systemName: "text.viewfinder")
                    .font(.largeTitle)
                    .minimumScaleFactor(0.5)
                Text("Preview")
                    .minimumScaleFactor(0.5)
                    .font(.footnote)
                    .textCase(.uppercase)
            }
            .padding()
        }
    }
    
    private var messageBox: some View {
        TextEditor(text: $message)
            .focused($isMessageFocused)
            .frame(width: columnWidth, height: rowItemHeight * 6)
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
                Text("Message")
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .offset(x: 16, y: 8)
            }

    }
    
    private var allButton: some View {
        Button {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            if everyoneIsChecked(in: customerListVM) {
                for customerVM in customerListVM.customerVMs {
                    customerVM.checked = false
                }
            } else {
                for customerVM in customerListVM.customerVMs {
                    customerVM.checked = true
                }
            }
            foobar.toggle()
        } label: {
            HStack {
                Text("All")
                    .font(.callout, weight: .bold)
                    .textCase(.uppercase)
                Image(systemName: everyoneIsChecked(in: customerListVM) ? "circle.inset.filled" : "circle" )
            }
            .padding(8)
            .addBorder(Color.accentColor, width: 0.6, cornerRadius: 6)
            .fixedSize()
        }
    }
    
    private var negativeBalanceButton: some View {
        Button {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            if negativeBalanceIsChecked(in: customerListVM) {
                for customerVM in customerListVM.customerVMs where customerVM.customer.balance < 0 {
                    customerVM.checked = false
                }
            } else {
                for customerVM in customerListVM.customerVMs where customerVM.customer.balance < 0 {
                    customerVM.checked = true
                }
            }
            foobar.toggle()
        } label: {
            HStack {
                Text("Negative balance")
                    .font(.callout, weight: .bold)
                    .textCase(.uppercase)
                    .lineLimit(1)
                Image(systemName: negativeBalanceIsChecked(in: customerListVM) ? "circle.inset.filled" : "circle" )
            }
            .padding(8)
            .addBorder(Color.accentColor, width: 0.6, cornerRadius: 6)
            .fixedSize()
        }
    }
    
    private var positiveBalanceButton: some View {
        Button {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            if positiveBalanceIsChecked(in: customerListVM) {
                for customerVM in customerListVM.customerVMs where customerVM.customer.balance > 0 {
                    customerVM.checked = false
                }
            } else {
                for customerVM in customerListVM.customerVMs where customerVM.customer.balance > 0 {
                    customerVM.checked = true
                }
            }
            foobar.toggle()
        } label: {
            HStack {
                Text("Positive balance")
                    .font(.callout, weight: .bold)
                    .textCase(.uppercase)
                    .lineLimit(1)
                Image(systemName: positiveBalanceIsChecked(in: customerListVM) ? "circle.inset.filled" : "circle" )
            }
            .padding(8)
            .addBorder(Color.accentColor, width: 0.6, cornerRadius: 6)
            .fixedSize()
        }
    }
        
    private var sendListHeader: some View {
        HStack {
            Text("Sending to:")
                .textCase(.uppercase)
                .font(.callout, weight: .bold)
            Spacer()
            Text("\(mailingListAmount)")
        }
        .frame(width: columnWidth, height: rowItemHeight / 4)
        .padding()
        .background(Color.accentColor)
        .foregroundColor(.black)
        .cornerRadius([.topLeading, .topTrailing], 6)
        .padding(.top, 24)
    }
    
    private var sendList: some View {
        ForEach(customerListVM.customerVMs) { customerVM in
            if customerVM.checked {
                CustomerEmailRow(customerVM: customerVM, columnWidth: columnWidth, rowItemHeight: rowItemHeight)
                    .onTapGesture {
                        isMessageFocused = false
                        withAnimation {
                            customerVM.checked.toggle()
                        }
                        foobar.toggle()
                    }
            }
        }
    }
    private var remainingList: some View {
        ForEach(customerListVM.customerVMs) { customerVM in
            if !customerVM.checked {
                CustomerEmailRow(customerVM: customerVM, columnWidth: columnWidth, rowItemHeight: rowItemHeight)
                    .onTapGesture {
                        isMessageFocused = false
                        withAnimation {
                            customerVM.checked.toggle()
                        }
                        foobar.toggle()
                    }
            }
        }
    }
    
    private var remainingListHeader: some View {
        HStack {
            Text("Not sending to:")
                .textCase(.uppercase)
                .font(.footnote)
            Spacer()
            Image(systemName: showingCustomers ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        }
        .frame(width: columnWidth, height: rowItemHeight / 4)
        .padding()
        .foregroundColor(.accentColor)
        .cornerRadius([.topLeading, .topTrailing], 6)
        .onTapGesture {
            withAnimation {
                showingCustomers.toggle()
            }
        }
        .contentShape(Rectangle())
    }

    private var actionButtons: some View {
        HStack {
            Spacer()
            Button("Close") {
                presenting = false
            }
            .padding(.horizontal)
            Spacer()
            Button {
                errorPrompt = ErrorPrompt(title: "Are you sure you want to send e-mail(s)?", message: "This will send an e-mail showing current balance to the chosen bar guests.")
                showError = true
            } label: {
                HStack {
                    Text("Send")
                    Image(systemName: "paperplane")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .foregroundColor(.black)
            }
            .background(Color.accentColor)
            .cornerRadius(6)
            .alert(errorPrompt?.title ?? LocalizedStringKey("There was an error"), isPresented: $showError, presenting: errorPrompt, actions: { prompt in
                Button("Cancel") {
                    showError = false
                }
                AsyncButton(action: {
                    await emailButtonAction(customerVMs: customerListVM.customerVMs)
                }, label: {
                    Text("OK")
                })
            }, message: { prompt in
                Text(prompt.message)
            })

            Spacer()
        }
        .padding(.vertical, 48)
        .toast(isPresented: $isShowingEmailConfirmation, dismissAfter: 6, onDismiss: {
            withAnimation {
                isShowingEmailConfirmation = false
                presenting = false
            }
        }) {
            ToastView(systemImage: ("envelope.fill", .accentColor, 50), title: "E-mail(s) sent", subTitle: "An e-mail showing current balance was sent to the chosen bar guests.")
        }
    }
    
    private func nooneIsChecked(in customerListVM: CustomerListViewModel) -> Bool {
        let checkedArray = customerListVM.customerVMs.filter { $0.checked == true }
        return checkedArray.isEmpty
    }
    
    private func everyoneIsChecked(in customerListVM: CustomerListViewModel) -> Bool {
        let checkedArray = customerListVM.customerVMs.filter { $0.checked == false }
        return checkedArray.isEmpty
    }
    
    private func negativeBalanceIsChecked(in customerListVM: CustomerListViewModel) -> Bool {
        let negativeBalanceArray = customerListVM.customerVMs.filter{$0.customer.balance < 0}
        let checkedArray = negativeBalanceArray.filter { $0.checked == false }
        return checkedArray.isEmpty
    }
    
    private func positiveBalanceIsChecked(in customerListVM: CustomerListViewModel) -> Bool {
        let positiveBalanceArray = customerListVM.customerVMs.filter{$0.customer.balance > 0}
        let checkedArray = positiveBalanceArray.filter { $0.checked == false }
        return checkedArray.isEmpty
    }
    
    private func emailButtonAction(customerVMs: [CustomerViewModel]) async {
        let checked = customerVMs.filter { $0.checked == true }
        let recipients = checked.map { $0.customer }
        do {
            try await customerListVM.sendEmails(from: userHandler.user, to: recipients, with: message)
            withAnimation {
                isShowingEmailConfirmation.toggle()
            }
        } catch {
            errorPrompt = ErrorPrompt(title: "Error sending emails", message: "")
            showError = true
        }
    }
}

struct CustomerEmailRow: View {
    @EnvironmentObject var userHandler: UserHandling

    var customerVM: CustomerViewModel
    let columnWidth: CGFloat
    let rowItemHeight: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: customerVM.checked ? "checkmark.circle" : "circle")
                .foregroundColor(customerVM.checked ? .accentColor : .gray)
            Text(customerVM.customer.name)
            Spacer()
            Text(Currency.display(customerVM.customer.balance, with: userHandler.user))
                .foregroundColor(customerVM.balanceColor)
                .multilineTextAlignment(.trailing)
        }
        .frame(width: columnWidth, height: rowItemHeight)
        .contentShape(Rectangle())
    }
}
