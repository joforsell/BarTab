//
//  PaywallView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import Foundation
import SwiftUI
import Purchases
import FirebaseAuth

struct PaywallView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var userHandler: UserHandling
    @ObservedObject var paywallVM = PaywallViewModel()
    
    var columnWidth: CGFloat {
        if isPhone() {
            return UIScreen.main.bounds.width
        } else {
            return 500
        }
    }
    
    @State private var isShowingLoginView = false
    @State private var isShowingSubscriptionDetails = false
    @State private var isShowingAlert = false
    
    @State private var alertTitle: LocalizedStringKey = ""
    @State private var alertMessage: LocalizedStringKey = ""
    
    var body: some View {
        ZStack {
            Image("backgroundbar")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            BackgroundBlob()
                .fill(.black)
                .blur(radius: 80)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Spacer()
                    Image("beer")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .frame(width: columnWidth * 0.3)
                        .padding()
                    Image("logotext")
                        .frame(width: columnWidth * 0.1)
                        .padding(.bottom, 48)
                    Spacer()
                    sellingPoints
                    Spacer()
                    HStack(spacing: isPhone() ? 8 : 16) {
                        SubButton(package: paywallVM.offerings?.monthly,
                                  selection: .monthly,
                                  selectedSub: $paywallVM.selectedSub)
                        SubButton(package: paywallVM.offerings?.annual,
                                  selection: .annual,
                                  selectedSub: $paywallVM.selectedSub)
                        SubButton(package: paywallVM.offerings?.lifetime,
                                  selection: .lifetime,
                                  selectedSub: $paywallVM.selectedSub)
                    }
                    .padding(.horizontal, isPhone() ? 8 : 0)
                    Group {
                        subContinueButton
                        HStack {
                            Spacer()
                            Link(LocalizedStringKey("Privacy policy"), destination: URL(string: "https://bartab.info/privacypolicy.html")!)
                                .foregroundColor(.accentColor)
                            Text("and")
                            Link(LocalizedStringKey("Terms of use"), destination: URL(string: "https://bartab.info/termsandconditions.html")!)
                                .foregroundColor(.accentColor)
                            Spacer()
                        }
                            .frame(width: columnWidth * 0.8)
                            .font(.callout)
                            .padding(.bottom, 16)
                        logoutButton
                            .padding(.bottom, 48)
                    }
                    HStack(spacing: 2) {
                        Button {
                            isShowingSubscriptionDetails.toggle()
                        } label: {
                            Text("Subscription details")
                            Image(systemName: "chevron.up")
                                .rotationEffect(.degrees(isShowingSubscriptionDetails ? 0 : 180))
                                .font(.footnote)
                                .animation(.easeInOut, value: isShowingSubscriptionDetails)
                        }
                        .sheet(isPresented: $isShowingSubscriptionDetails) {
                            SubscriptionDetailsView()
                                .clearModalBackground()
                        }
                        Spacer()
                        Button {
                            if let newUserID = Auth.auth().currentUser?.uid {
                                Purchases.shared.restoreTransactions { purchaserInfo, error in
                                    if error != nil {
                                        alertTitle = "Restoration failed"
                                        alertMessage = "Your purchase could not be restored, no valid reciept was found."
                                        isShowingAlert = true
                                    } else {
                                        if let oldUserID = purchaserInfo?.originalAppUserId {
                                            paywallVM.transferData(from: oldUserID, to: newUserID)
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Restore purchase")
                        }
                        .alert(isPresented: $isShowingAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .frame(width: columnWidth * 0.8)
                    .font(.callout)
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: columnWidth)
                .center(.horizontal)
            }
        }
    }
}

// MARK: - Selling points view

private extension PaywallView {
    @ViewBuilder
    private var sellingPoints: some View {
        ContentRow(width: columnWidth,
                   headerText: "Stay on top of things",
                   bodyText: "Forget tallying purchases and adding up balance after every night. With BarTab you and your bar guests can easily keep track of running tabs.",
                   image: Image(systemName: "dollarsign.circle.fill"),
                   isPhone: isPhone())
        ContentRow(width: columnWidth,
                   headerText: "Unlimited list of bar guests",
                   bodyText: "Add an unlimited amount of bar guests with balances that are updated automatically and let them order from a drink list only limited by the contents of your bar.",
                   image: Image(systemName: "person.2.circle.fill"),
                   isPhone: isPhone())
        ContentRow(width: columnWidth,
                   headerText: "Send e-mail with current balance",
                   bodyText: "Letting your bar guests keep track of their balance should be easy. With the press of a button you can e-mail each of your bar guests their current balance.",
                   image: Image(systemName: "envelope.fill"),
                   isPhone: isPhone())
            .padding(.bottom, 48)
    }
    
// MARK: - Button views
    
    private var subContinueButton: some View {
        Button {
            switch paywallVM.selectedSub {
            case .monthly:
                guard let monthlyPackage = paywallVM.offerings?.monthly else { return }
                return paywallVM.purchase(package: monthlyPackage) { completed in
                    if completed {
                        authentication.userAuthState = .subscribed
                        if let user = Auth.auth().currentUser {
                            Purchases.shared.setEmail(user.email)
                        }
                    }
                }
            case .annual:
                guard let annualPackage = paywallVM.offerings?.annual else { return }
                return paywallVM.purchase(package: annualPackage) { completed in
                    if completed {
                        authentication.userAuthState = .subscribed
                        if let user = Auth.auth().currentUser {
                            Purchases.shared.setEmail(user.email)
                        }
                    }
                }
            case .lifetime:
                guard let lifetimePackage = paywallVM.offerings?.lifetime else { return }
                return paywallVM.purchase(package: lifetimePackage) { completed in
                    if completed {
                        authentication.userAuthState = .subscribed
                        if let user = Auth.auth().currentUser {
                            Purchases.shared.setEmail(user.email)
                        }
                    }
                }
            }
        } label: {
            RoundedRectangle(cornerRadius: 6)
                .frame(height: 80)
                .foregroundColor(.accentColor)
                .overlay {
                    VStack {
                        ContinueButtonText(selectedSub: $paywallVM.selectedSub, offerings: paywallVM.offerings)
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(2)
                    }
                }
        }
        .padding(.vertical)
        .padding(.top)
        .padding(.horizontal, isPhone() ? 8 : 0)
    }
    
    private var logoutButton: some View {
        Button {
            UserHandling.signOut { _ in }
        } label: {
            Text("Sign out")
                .foregroundColor(.white)
                .font(.callout)
                .fontWeight(.semibold)
        }
    }
    
    private struct ContinueButtonText: View {
        @Binding var selectedSub: PaywallViewModel.Subscription
        let offerings: Purchases.Offering?
        
        var body: some View {
            switch selectedSub {
            case .monthly:
                return VStack {
                    Text("\(offerings?.monthly?.localizedPriceString ?? "Price not found") / month")
                        .fontWeight(.bold)
                    Text("First week for free!")
                        .font(.caption2)
                }
            case .annual:
                return VStack {
                    Text("\(offerings?.annual?.localizedPriceString ?? "Price not found") / year")
                        .fontWeight(.bold)
                    Text("First week for free!")
                        .font(.caption2)
                }
            case .lifetime:
                return VStack {
                    Text("\(offerings?.lifetime?.localizedPriceString ?? "Price not found")")
                        .fontWeight(.bold)
                    Text("Pay only once!")
                        .font(.caption2)
                }
            }
        }
    }
    
    struct SubButton: View {
        let package: Purchases.Package?
        let selection: PaywallViewModel.Subscription
        @Binding var selectedSub: PaywallViewModel.Subscription
        
        var body: some View {
            Button {
                withAnimation {
                    selectedSub = selection
                }
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 160)
                    .foregroundColor(selectedSub == selection ? .accentColor : .clear)
                    .border(Color.accentColor, width: 1, cornerRadius: 6)
                    .overlay {
                        VStack {
                            Text(package?.product.localizedTitle ?? "")
                                .font(.callout)
                            Text(package?.localizedPriceString ?? "Price not found")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .padding(.horizontal, 2)
                    }
            }
        }
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}



// MARK: - Content rows for selling points

private extension PaywallView {
    struct ContentRow: View {
        let width: CGFloat
        let headerText: LocalizedStringKey
        let bodyText: LocalizedStringKey
        let image: Image
        let isPhone: Bool
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(headerText)
                    .fontWeight(.black)
                Text(bodyText)
                    .fontWeight(.thin)
            }
            .frame(maxWidth: width, alignment: .leading)
            .padding()
            .padding(.leading, isPhone ? 40 : 0)
            .overlay(alignment: .topLeading) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.horizontal, 20)
                    .offset(x: isPhone ? -8 : -(width * 0.1), y: width * 0.04)
            }
        }
    }
}
