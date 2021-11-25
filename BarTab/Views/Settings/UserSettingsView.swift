//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
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
    
    @State private var isShowingLoginScreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Mailadress: \(userInfo.user.email ?? "Ej angiven")")
            Divider()
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
            Divider()
            Toggle("Använd RFID-taggar", isOn: $settingsManager.settings.usingTag)
                .toggleStyle(SwitchToggleStyle(tint: Color("AppYellow")))
            if let currentUser = Auth.auth().currentUser {
                if !currentUser.isAnonymous {
                    Divider()
                    Toggle("Begär adminlösenord", isOn: $settingsManager.settings.requestingPassword)
                        .toggleStyle(SwitchToggleStyle(tint: Color("AppYellow")))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.4)
        .foregroundColor(.white)
        .padding(.horizontal)
        .background(Color("AppBlue"))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
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
                        .padding()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if let currentUser = Auth.auth().currentUser {
                        if currentUser.isAnonymous {
                            isShowingLoginScreen.toggle()
                        }
                    }
                } label: {
                    if let currentUser = Auth.auth().currentUser {
                        if currentUser.isAnonymous {
                            Text("Logga in")
                                .background(Color("AppYellow"))
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Kunde inte logga ut"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $isShowingLoginScreen) {
            LoginView()
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

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
            .environmentObject(UserInfo())
    }
}
