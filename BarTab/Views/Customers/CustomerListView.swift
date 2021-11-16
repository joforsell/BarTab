//
//  CustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct CustomerListView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    @State private var isShowingAddMemberSheet = false
    
    var body: some View {
        NavigationView {
                List {
                    ForEach(customerListVM.customerVMs) { customerVM in
                        NavigationLink(destination: CustomerDetailView(customerVM: customerVM)) {
                            HStack {
                                Text(customerVM.customer.name)
                                Spacer()
                                Text("\(customerVM.customer.balance) kr")
                                    .foregroundColor(customerVM.customer.balance < 0 ? .red : .green)
                            }
                        }
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("Medlemmar")
                        }
                        .font(.largeTitle)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { isShowingAddMemberSheet = true
                        } label: {
                            Image(systemName: "person.fill.badge.plus")
                        }
                        .padding()
                        .foregroundColor(.black)
                        .font(.largeTitle)
                    }
                }
                .sheet(isPresented: $isShowingAddMemberSheet) {
                    AddCustomerView()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
}
    
struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            CustomerListView()
                .environmentObject(CustomerListViewModel())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            CustomerListView()
                .environmentObject(CustomerListViewModel())
        }
    }
}
