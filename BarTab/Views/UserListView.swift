//
//  UserListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject var userStore: UserStore
    
    @State private var isShowingAddMemberSheet = false
    @State private var editingBalanceMode = false
    
    var body: some View {
        VStack {
            HStack {
                Label("Medlemmar", systemImage: "person.2.fill")
                    .font(.system(size: 30))
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                Spacer()
                Button(action: { isShowingAddMemberSheet = true }) {
                    Image(systemName: "person.fill.badge.plus")
                }
                .padding(.vertical)
                .foregroundColor(.black)
                .font(.system(size: 30))
                Button(action: { editingBalanceMode.toggle() }) {
                    Image(systemName: "dollarsign.circle.fill")
                }
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 30))
            }
            List {
                ForEach(userStore.users) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if editingBalanceMode {
                            // TODO: Add pop-up numpad to type addition or subtraction.
                            Image(systemName: "minus.circle.fill")
                                .onTapGesture { userStore.subtractFromBalanceOf(user.id) }
                                .foregroundColor(.red)
                            Image(systemName: "plus.circle.fill")
                                .onTapGesture { userStore.addToBalanceOf(user.id) }
                                .foregroundColor(.green)
                        }
                        Text("\(user.balance) kr")
                            .foregroundColor(user.balance < 0 ? .red : .green)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddMemberSheet) {
            AddUserView()
        }
    }
}


struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            UserListView()
                .environmentObject(UserStore())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            UserListView()
                .environmentObject(UserStore())
        }
    }
}
