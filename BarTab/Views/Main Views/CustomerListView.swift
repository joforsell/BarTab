//
//  CustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI
import SwiftUIX

struct CustomerListView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
        
    var body: some View {
        VStack {
            ScrollView {
                ForEach(customerListVM.customerVMs) { customerVM in
                    customerRow(customerVM)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width * 0.3)
        .background(Color.black.opacity(0.6))
        .padding(.leading, 10)
    }
    
    func customerRow(_ customerVM: CustomerViewModel) -> some View {
        HStack(alignment: .center) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.6)
                .frame(height: 50)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                }
            VStack(alignment: .leading) {
                Text(customerVM.customer.name)
                    .font(.callout)
                Text("\(customerVM.customer.balance) kr")
                    .font(.footnote)
                    .foregroundColor(customerVM.balanceColor)
            }
            Spacer()
            Image(systemName: "wave.3.right.circle.fill")
        }
        .foregroundColor(.white)
        .padding()
        .background(VisualEffectBlurView(blurStyle: .dark))
        .frame(height: 60, alignment: .leading)
        .cornerRadius(10)
        .addBorder(Color.white.opacity(0.1), width: 1, cornerRadius: 10)
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
            .previewLayout(.sizeThatFits)
            .environmentObject(CustomerListViewModel())
    }
}
