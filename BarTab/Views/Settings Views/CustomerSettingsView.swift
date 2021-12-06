//
//  CustomerSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct CustomerSettingsView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userInfo: UserInfo
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
        
    @State private var showError = false
    @State private var errorString = ""
    
    @Binding var isShowingEmailSuccessToast: Bool
    
    @State private var isShowingEmailConfirmation = false
    @State private var isShowingAddMemberSheet = false

    
    var body: some View {
        VStack {
            List {
                ForEach($customerListVM.customerVMs) { $customerVM in
                    CustomerRow(customerVM: $customerVM)
                }
            }
            .navigationTitle("Medlemmar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    emailButton
                        .alert(isPresented: $isShowingEmailConfirmation) {
                            Alert(title: Text("Vill du göra ett mailutskick?"),
                                  message: Text("Vill du skicka ett mail med nuvarande saldo till samtliga kunder?"),
                                  primaryButton: .destructive(Text("Avbryt"), action: { isShowingEmailConfirmation = false }),
                                  secondaryButton: .default(Text("OK"), action: emailButtonAction)
                            )
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCustomerButton
                        .sheet(isPresented: $isShowingAddMemberSheet) {
                            AddCustomerView()
                        }
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Kunde inte göra mailutskick"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
        
    }
    
    func oneDayHasElapsedSince(_ date: Date) -> Bool {
        let timeSinceLatestEmail = -latestEmail.timeIntervalSinceNow
        return timeSinceLatestEmail > 86400
    }
    
    var addCustomerButton: some View {
        Button { isShowingAddMemberSheet = true
        } label: {
            Image(systemName: "person.fill.badge.plus")
                .foregroundColor(.accentColor)
                .font(.largeTitle)
        }
        .padding(.trailing)
        .offset(y: 30)
    }
    
    var emailButton: some View {
        Button {
            if oneDayHasElapsedSince(latestEmail) {
                isShowingEmailConfirmation.toggle()
            } else {
                errorString = "Du kan inte göra mailutskick oftare än var 24:e timma."
                showError.toggle()
            }
        } label: {
            Image(systemName: "envelope.fill")
                .font(.largeTitle)
                .foregroundColor(oneDayHasElapsedSince(latestEmail) ? .accentColor : .accentColor.opacity(0.3))
        }
        .offset(y: 30)
    }
    
    func emailButtonAction() {
        customerListVM.sendEmails(from: userInfo.user.association) { result in
            switch result {
            case .failure(let error):
                errorString = error.localizedDescription
                showError = true
            case .success( _):
                latestEmail = Date()
            }
        }
        latestEmail = Date()
        withAnimation {
            isShowingEmailSuccessToast.toggle()
        }
    }
}

struct CustomerRow: View {
    @Binding var customerVM: CustomerViewModel
    
    @State private var showingNumpad = false
    
    var body: some View {
        NavigationLink(destination: CustomerSettingsDetailView(customerVM: $customerVM)) {
            HStack {
                Text(customerVM.customer.name)
                Spacer()
                Text("\(customerVM.customer.balance) kr")
            }
        }
    }
}

struct CustomerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSettingsView(isShowingEmailSuccessToast: .constant(false))
    }
}
