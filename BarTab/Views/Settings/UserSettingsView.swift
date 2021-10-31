//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var settings: UserSettingsViewModel
    
    @State private var association = ""
    @State private var editingAssociation = false
    
    @State private var showError = false
    @State private var errorString = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mailadress: \(userInfo.user.email)")
            HStack {
                if editingAssociation {
                    Text("Organisation:")
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
            Toggle("Använd RFID-taggar", isOn: $settings.settings.usingTag)
                .toggleStyle(SwitchToggleStyle(tint: Color("AppYellow")))
        }
        .onAppear {
            if !userInfo.user.settingsLoaded {
                settings.createSettings()
            }
            userInfo.user.settingsLoaded = true
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
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Kunde inte logga ut"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
    }
    
    func updateAssociation(to: String) {
        let data = User.dataDict(
            uid: userInfo.user.uid,
            email: userInfo.user.email,
            association: association,
            settingsLoaded: userInfo.user.settingsLoaded
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
