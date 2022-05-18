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
    
    @State private var currentCustomer: Binding<Customer>? = nil
        
    var body: some View {
        ZStack {
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
                    ForEach($customerListVM.customerVMs) { $customerVM in
                        CustomerRow(customerVM: $customerVM)
                            .padding(.bottom, isPhone() ? customerListVM.customerVMs.last?.name == customerVM.name ? 48 : 0 : 0)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    currentCustomer = $customerVM.customer
                                }
                            }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(width: isPhone() ? UIScreen.main.bounds.width : UIScreen.main.bounds.width * 0.3)
            .background(isPhone() ? Color.clear : Color.black.opacity(0.6))
            .padding(.leading, isPhone() ? 0 : 10)
            if currentCustomer != nil {
                TransactionsListView(customer: currentCustomer!, onClose: close)
                    .frame(width: isPhone() ? UIScreen.main.bounds.width : UIScreen.main.bounds.width * 0.3)
                    .cornerRadius(isPhone() ? 0 : 10)
                    .transition(.move(edge: .trailing))
                    .zIndex(3)
            }
        }
    }
    
    struct CustomerRow: View {
        @EnvironmentObject var userHandler: UserHandling
        @Binding var customerVM: CustomerViewModel
        
        var body: some View {
            HStack(alignment: .center) {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 50, height: 50)
                    .background {
                        CacheableAsyncImage(url: $customerVM.profilePictureUrl, animation: .easeIn, transition: .opacity) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    }
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxHeight: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                            case .failure( _):
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(0.6)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                VStack(alignment: .leading) {
                    Text(customerVM.customer.name)
                        .font(.callout)
                    Text(Currency.display(Float(customerVM.customer.balance), with: userHandler.user))
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
    }

    private func close() {
        withAnimation {
            currentCustomer = nil
        }
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
