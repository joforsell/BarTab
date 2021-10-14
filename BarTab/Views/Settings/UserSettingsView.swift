//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var association = ""
    @State private var editingAssociation = false
    
    @State private var showError = false
    @State private var errorString = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Användarnamn: \(userInfo.user.displayName)")
            Text("Mailadress: \(userInfo.user.email)")
            HStack {
                if editingAssociation {
                    Text("Företag eller förening:")
                    TextField("\(userInfo.user.association ?? "Ej angett")", text: $association, onCommit: {
                        if association != "" {
                            updateAssociation(to: association)
                        }
                        editingAssociation.toggle()
                    })
                    Button {
                        if association != "" {
                            updateAssociation(to: association)
                        }
                        editingAssociation.toggle()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.black)
                    }
                } else {
                    Text("Företag eller förening: \(userInfo.user.association ?? "Ej angett")")
                    Button {
                        editingAssociation.toggle()
                        association = ""
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .navigationTitle("Inloggad som \(userInfo.user.displayName)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Authentication.logout() { result in
                        switch result {
                        case .failure(let error):
                            errorString = error.localizedDescription
                            showError = true
                        case .success( _):
                            print("Loggades ut!")
                        }
                    }
                } label: {
                    Label("Logga ut", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Kunde inte logga ut"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
    }
    
    func updateAssociation(to: String) {
        let data = User.dataDict(
            uid: userInfo.user.uid,
            displayName: userInfo.user.displayName,
            email: userInfo.user.email,
            association: association
        )
        
        UserHandling.mergeUser(data, uid: userInfo.user.uid) { _ in
            
        }
        
        userInfo.user.association = association
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
