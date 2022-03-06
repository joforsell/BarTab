//
//  CustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI
import SwiftUIX

struct CustomerListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userHandler: UserHandling
        
    var body: some View {
        VStack {
            if isPhone() {
                HStack {
                    Image(uiImage: Bundle.main.icon ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                        .padding(8)
                    Text(userHandler.user.association ?? "BarTab")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                    Spacer()
                }
            }
            ScrollView {
                ForEach(customerListVM.customerVMs) { customerVM in
                    customerRow(customerVM)
                        .padding(.bottom, isPhone() ? customerListVM.customerVMs.last?.name == customerVM.name ? 48 : 0 : 0)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(width: isPhone() ? UIScreen.main.bounds.width : UIScreen.main.bounds.width * 0.3)
        .background(isPhone() ? Color.clear : Color.black.opacity(0.6))
        .padding(.leading, isPhone() ? 0 : 10)
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
            Image(systemName: customerVM.customer.key.isEmpty ? "wave.3.right.circle" : "wave.3.right.circle.fill")
                .foregroundColor(customerVM.customer.key.isEmpty ? .white.opacity(0.05) : .white)
        }
        .foregroundColor(.white)
        .padding()
        .background(VisualEffectBlurView(blurStyle: .dark))
        .frame(height: 60, alignment: .leading)
        .cornerRadius(10)
        .addBorder(Color.white.opacity(0.1), width: 1, cornerRadius: 10)
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
