//
//  CustomerSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct CustomerSettingsView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    var geometry: GeometryProxy
    @Binding var detailViewShown: DetailViewRouter
    
    @State private var isShowingAddCustomerView = false
    @State private var currentCustomerShown: CustomerViewModel?
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach($customerListVM.customerVMs) { $customerVM in
                        VStack(spacing: 0) {
                            CustomerRow(customerVM: $customerVM, geometry: geometry)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(currentCustomerShown?.id == customerVM.id ? Color("AppBlue") : Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if currentCustomerShown?.id == customerVM.id {
                                        detailViewShown = .none
                                        currentCustomerShown = nil
                                    } else {
                                        detailViewShown = .customer(customerVM: $customerVM, detailsViewShown: $detailViewShown)
                                        currentCustomerShown = customerVM
                                    }
                                }
                            Divider()
                        }

                    }
                }
            }
            .padding(.top)
            .frame(width: geometry.size.width * 0.25)
            .overlay(alignment: .bottomTrailing) {
                addCustomerButton
                    .sheet(isPresented: $isShowingAddCustomerView) {
                        AddCustomerView()
                            .clearModalBackground()
                    }
            }
        }
        .background(Color.black.opacity(0.3))
    }
        
    var addCustomerButton: some View {
        Button {
            isShowingAddCustomerView.toggle()
        } label: {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .padding()
                .frame(width: 90)
        }
    }
}

private struct CustomerRow: View {
    @EnvironmentObject var userHandler: UserHandling

    @Binding var customerVM: CustomerViewModel
    var geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(0.6)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                }
            VStack(alignment: .leading) {
                Text(customerVM.customer.name)
                    .font(.callout)
                    .fontWeight(.bold)
                Text(Currency.display(Float(customerVM.customer.balance), with: userHandler.user))
                    .font(.footnote)
                    .foregroundColor(customerVM.balanceColor)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.white.opacity(0.2))
        }
        .foregroundColor(.white)
        .frame(height: geometry.size.height * 0.05)
    }
}

