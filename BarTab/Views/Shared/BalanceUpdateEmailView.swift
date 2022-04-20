//
//  BalanceUpdateEmailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-19.
//

import SwiftUI
import SwiftUIX

struct BalanceUpdateEmailView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    @Binding var presenting: Bool
    
    @FocusState private var isMessageFocused: Bool
    
    @State var showingPreview = false
    @State var message = ""
    @State var foobar = false
    @State var showingCustomers = false
    var mailingListAmount: Int {
        return customerListVM.customerVMs.filter({$0.checked == true}).count
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
                    KeyboardAvoiding(with: avoider) {
                        messageBox
                    }
                    VStack(alignment: .center) {
                        sendListHeader
                        sendList
                        remainingListHeader
                        if showingCustomers {
                            remainingList
                        }
                    }
                    buttons
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlurEffectView(style: .dark).ignoresSafeArea())
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
                Image(systemName: "text.quote")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(height: 30)
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

    private var buttons: some View {
        HStack {
            Spacer()
            Button("Close") {
                presenting = false
            }
            .padding(.horizontal)
            Spacer()
            Button {
                presenting = false
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
            Spacer()
        }
        .padding(.top, 48)
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
