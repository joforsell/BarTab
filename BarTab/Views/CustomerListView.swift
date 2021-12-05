//
//  CustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct CustomerListView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    @State private var isShowingAddCustomerView = false
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(customerListVM.customerVMs) { customerVM in
                    customerRow(customerVM)
                }
            }
            Spacer()
            addCustomerButton
                .sheet(isPresented: $isShowingAddCustomerView) {
                    AddCustomerView()
                }
        }
        .padding(.trailing, 48)
        .padding(.leading, 10)
        .background(Color.black.opacity(0.6))
        .frame(width: 400)
        .padding(.leading, 10)
    }
    
    func customerRow(_ customerVM: CustomerViewModel) -> some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.largeTitle)
            VStack(alignment: .leading) {
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
        .cornerRadius(10)
    }
    
    var addCustomerButton: some View {
        HStack {
            Spacer()
            Image(systemName: "person.crop.circle.badge.plus")
                .foregroundColor(.accentColor)
                .font(.system(size: 60))
                .padding(.vertical)
        }
        .onTapGesture {
            isShowingAddCustomerView.toggle()
        }
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
            .previewLayout(.sizeThatFits)
            .environmentObject(CustomerListViewModel())
    }
}
