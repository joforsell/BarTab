//
//  CustomerSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI
import AlertToast

struct CustomerSettingsView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userInfo: UserInfo
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
        
    @State private var showError = false
    @State private var errorString = ""
    
    @Binding var isShowingEmailSuccessToast: Bool
    @State private var isShowingEmailConfirmation = false
    
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
                    mailButton
                        .alert(isPresented: $isShowingEmailConfirmation) {
                            Alert(title: Text("Vill du göra ett mailutskick?"), message: Text("Vill du skicka ett mail med nuvarande saldo till samtliga kunder?"), primaryButton: .default(Text("OK"), action: emailButtonAction), secondaryButton: .destructive(Text("Avbryt")) { isShowingEmailConfirmation = false } )
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
    
    var mailButton: some View {
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
