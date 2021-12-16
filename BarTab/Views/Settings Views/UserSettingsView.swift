//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import FirebaseAuth

struct UserSettingsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var settingsManager: SettingsManager
    
    @State private var association = ""
    @State private var editingAssociation = false
    
    @State private var showError = false
    @State private var errorString = ""
        
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Image("bartender")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * 0.2)
                    .padding(.top, 48)
                HStack {
                    Text("Mailadress: \(userInfo.user.email ?? "Ej angiven")")
                    Spacer()
                }
                .frame(maxWidth: geometry.size.width * 0.4)
                Divider()
                    .frame(maxWidth: geometry.size.width * 0.4)
                HStack {
                    if editingAssociation {
                        Text("Organisation:")
                        TextField("\(userInfo.user.association ?? "Ej angiven")", text: $association, onCommit: {
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
                                .foregroundColor(Color("AppYellow"))
                                .font(.headline)
                        }
                    } else {
                        Text("Organisation: \(userInfo.user.association ?? "Ej angett")")
                        Button {
                            editingAssociation.toggle()
                            association = ""
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(Color("AppYellow"))
                                .font(.headline)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.4)
                Divider()
                    .frame(maxWidth: geometry.size.width * 0.4)
                Toggle("Använd RFID-taggar", isOn: $settingsManager.settings.usingTag)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .frame(maxWidth: geometry.size.width * 0.4)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .alert(isPresented: $showError) {
                Alert(title: Text("Kunde inte logga ut"), message: Text(errorString), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func updateAssociation(to: String) {
        let data = User.dataDict(
            uid: userInfo.user.uid,
            email: userInfo.user.email ?? "",
            association: association
        )
        
        UserHandling.mergeUser(data, uid: userInfo.user.uid) { result in
            switch result {
            case .failure(let error):
                errorString = error.localizedDescription
                showError = true
            case .success( _):
                print("Uppdaterade förening eller företag.")
            }
        }
        
        userInfo.user.association = association
    }
}

