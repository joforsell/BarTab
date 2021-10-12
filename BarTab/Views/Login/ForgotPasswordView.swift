//
//  ForgotPasswordView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var errString: String?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Mailadress", text: $user.email).autocapitalization(.none).keyboardType(.emailAddress).disableAutocorrection(true)
                Button(action: {
                    Authentication.resetPassword(email: user.email) { result in
                        switch result {
                        case .failure(let error):
                            errString = error.localizedDescription
                        case .success( _):
                            break
                        }
                        showAlert = true
                    }
                }) {
                    Text("Återställ lösenord")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .opacity(user.isEmailValid(_email: user.email) ? 1 : 0.75)
                }
                .disabled(!user.isEmailValid(_email: user.email))
                Spacer()
            }
            .padding(.top)
            .frame(width: 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationBarTitle("Begär lösenordsåterställning", displayMode: .inline)
            .navigationBarItems(trailing: Button("Stäng") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Lösenord återställt"), message: Text(errString ?? "Återställningsmailet skickades, kolla din inbox!"), dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
