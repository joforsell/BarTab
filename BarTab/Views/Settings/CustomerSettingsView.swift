//
//  CustomerSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct CustomerSettingsView: View {
    @EnvironmentObject var customerVM: CustomerViewModel
    @EnvironmentObject var userInfo: UserInfo
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)

    @State var editMode: EditMode = .inactive
    
    @State private var showError = false
    @State private var errorString = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(customerVM.customers) { customer in
                    HStack {
                        Text(customer.name)
                        Spacer()
                        if editMode == .active {
                            // TODO: Add pop-up numpad to type addition or subtraction.
                            Image(systemName: "minus.circle.fill")
                                .onTapGesture { customerVM.subtractFromBalance(of: customer.id!, by: 10) }
                                .foregroundColor(.red)
                            Image(systemName: "plus.circle.fill")
                                .onTapGesture { customerVM.addToBalance(of: customer.id!, by: 10) }
                                .foregroundColor(.green)
                        }
                        Text("\(customer.balance) kr")
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Medlemmar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if -latestEmail.timeIntervalSinceNow > 86400 {
                            customerVM.sendEmails(from: userInfo.user.association) { result in
                                switch result {
                                case .failure(let error):
                                    errorString = error.localizedDescription
                                    showError = true
                                case .success( _):
                                    latestEmail = Date()
                                }
                            }
                            latestEmail = Date()
                        } else {
                            errorString = "Du kan inte göra mailutskick oftare än var 24:e timma."
                            showError = true
                        }
                    } label: {
                        Image(systemName: "envelope.fill")
                            .font(.largeTitle)
                            .foregroundColor(-latestEmail.timeIntervalSinceNow > 86400 ? .black : .gray)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                }
            }
            .environment(\.editMode, $editMode)
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Kunde inte göra mailutskick"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            customerVM.removeCustomer(customerVM.customers[index].id!)
        }
        customerVM.customers.remove(atOffsets: offsets)
    }
    
    func hasOneDayElapsedSinceLatestEmail(_ date: Date) -> Bool {
        let timeSinceLatestEmail = -latestEmail.timeIntervalSinceNow
        return timeSinceLatestEmail > 86400
    }
}

struct CustomerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSettingsView()
    }
}
