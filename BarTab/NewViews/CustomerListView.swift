//
//  CustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct CustomerListView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(customerListVM.customerVMs) { customerVM in
                    HStack {
                        Image(systemName: "person.circle")
                        VStack {
                            Text(customerVM.customer.name)
                            Text("\(customerVM.customer.balance) kr")
                                .foregroundColor(customerVM.balanceColor)
                        }
                        Spacer()
                        Image(systemName: "wave.3.right.circle.fill")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("AppBlue"))
                    .frame(height: 60, alignment: .leading)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "person.crop.circle.badge.plus")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 60))
                    .padding(.vertical)
            }
        }
        .padding(.trailing, 48)
        .background(Color.black.opacity(0.6))
        .frame(width: 400)
        .padding(.leading, 10)
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
            .previewLayout(.sizeThatFits)
            .environmentObject(CustomerListViewModel())
    }
}
