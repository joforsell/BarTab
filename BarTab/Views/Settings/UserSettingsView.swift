//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var userVM: UserViewModel
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        VStack {
            List {
                ForEach(userVM.users) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if editMode == .active {
                            // TODO: Add pop-up numpad to type addition or subtraction.
                            Image(systemName: "minus.circle.fill")
                                .onTapGesture { userVM.subtractFromBalance(of: user.id!, by: 10) }
                                .foregroundColor(.red)
                            Image(systemName: "plus.circle.fill")
                                .onTapGesture { userVM.addToBalance(of: user.id!, by: 10) }
                                .foregroundColor(.green)
                        }
                        Text("\(user.balance) kr")
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Medlemmar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton()
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            userVM.removeUser(userVM.users[index].id!)
        }
        userVM.users.remove(atOffsets: offsets)
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
