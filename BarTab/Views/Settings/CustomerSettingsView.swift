//
//  CustomerSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct CustomerSettingsView: View {
    @EnvironmentObject var customerVM: CustomerViewModel
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        VStack {
            List {
                ForEach(customerVM.customers) { customer in
                    HStack {
                        Text(customer.name)
                        Spacer()
                        if editMode == .active {
                            // TODO: Add pop-up numpad to type addition or subtraction.
                            Image(systemName: "minus.circle.fill")
                                .onTapGesture { customerVM.subtractFromBalance(of: customer.id!, by: 10) }
                                .foregroundColor(.red)
                            Image(systemName: "plus.circle.fill")
                                .onTapGesture { customerVM.addToBalance(of: customer.id!, by: 10) }
                                .foregroundColor(.green)
                        }
                        Text("\(customer.balance) kr")
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
            customerVM.removeCustomer(customerVM.customers[index].id!)
        }
        customerVM.customers.remove(atOffsets: offsets)
    }
}

struct CustomerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSettingsView()
    }
}
