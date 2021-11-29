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
        VStack(spacing: 10) {
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
                .background(Color("AppBlue"))
                .frame(height: 60, alignment: .leading)
            }
        }
        .background(.black.opacity(0.6))
        .frame(width: Constants.screenSizeWidth*0.6)
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
            .previewLayout(.sizeThatFits)
            .environmentObject(CustomerListViewModel())
    }
}
