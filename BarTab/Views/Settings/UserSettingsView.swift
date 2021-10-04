//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.editMode) var editMode
    
    @State private var editingBalanceMode = false
    
    var body: some View {
        VStack {
            List(userVM.users) { user in
                HStack {
                    Text(user.name)
                    Spacer()
                    if editMode?.wrappedValue.isEditing ?? false {
                        // TODO: Add pop-up numpad to type addition or subtraction.
                        Image(systemName: "minus.circle.fill")
                            .onTapGesture { userVM.subtractFromBalance(of: user.id!) }
                            .foregroundColor(.red)
                        Image(systemName: "plus.circle.fill")
                            .onTapGesture { userVM.addToBalance(of: user.id!) }
                            .foregroundColor(.green)
                    }
                    Text("\(user.balance) kr")
                }
            }
            .navigationTitle("Medlemmar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton()
//                    Button(action: { editingBalanceMode.toggle() }) {
//                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
//                    }
                }
            }
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
