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
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Mailadress", text: $user.email).autocapitalization(.none).keyboardType(.emailAddress).disableAutocorrection(true)
                Button(action: {
                    // Återställ lösenord
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
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
