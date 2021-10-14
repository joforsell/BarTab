//
//  UserListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject var customerVM: CustomerViewModel
    
    @State private var isShowingAddMemberSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Label("Medlemmar", systemImage: "person.2.fill")
                    .font(.largeTitle)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                Spacer()
                Button(action: { isShowingAddMemberSheet = true }) {
                    Image(systemName: "person.fill.badge.plus")
                }
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 30))
            }
            List {
                ForEach(customerVM.customers) { customer in
                    HStack {
                        Text(customer.name)
                        Spacer()
                        Text("\(customer.balance) kr")
                            .foregroundColor(customer.balance < 0 ? .red : .green)
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
                .environmentObject(CustomerViewModel())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            UserListView()
                .environmentObject(CustomerViewModel())
        }
    }
}
