//
//  CustomerSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct CustomerSettingsView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userInfo: UserInfo
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
        
    @State private var showError = false
    @State private var errorString = ""
    
    @Binding var isShowingEmailSuccessToast: Bool
    var geometry: GeometryProxy
    @Binding var detailViewShown: DetailViewRouter
    
    @State private var isShowingEmailConfirmation = false
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
                                .background(currentCustomerShown?.customer.name == customerVM.customer.name ? Color("AppBlue") : Color.clear)
                                .onTapGesture {
                                    detailViewShown = .customer(customerVM: $customerVM, geometry: geometry)
                                    currentCustomerShown = customerVM
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
                    }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Kunde inte göra mailutskick"), message: Text(errorString), dismissButton: .default(Text("OK")))
            }
        }
        .background(Color.black.opacity(0.3))
    }
    
    func oneDayHasElapsedSince(_ date: Date) -> Bool {
        let timeSinceLatestEmail = -latestEmail.timeIntervalSinceNow
        return timeSinceLatestEmail > 86400
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

    
    var emailButton: some View {
        Button {
            if oneDayHasElapsedSince(latestEmail) {
                isShowingEmailConfirmation.toggle()
            } else {
                errorString = "Du kan inte göra mailutskick oftare än var 24:e timma."
                showError.toggle()
            }
        } label: {
            Image(systemName: "envelope.fill")
                .font(.largeTitle)
                .foregroundColor(oneDayHasElapsedSince(latestEmail) ? .accentColor : .accentColor.opacity(0.3))
        }
    }
    
    func emailButtonAction() {
        customerListVM.sendEmails(from: userInfo.user.association) { result in
            switch result {
            case .failure(let error):
                errorString = error.localizedDescription
                showError = true
            case .success( _):
                latestEmail = Date()
            }
        }
        latestEmail = Date()
        withAnimation {
            isShowingEmailSuccessToast.toggle()
        }
    }
}

struct CustomerRow: View {
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
                Text("\(customerVM.customer.balance) kr")
                    .font(.footnote)
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

