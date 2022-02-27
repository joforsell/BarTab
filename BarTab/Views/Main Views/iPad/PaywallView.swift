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
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var userHandler: UserHandling
    @ObservedObject var paywallVM = PaywallViewModel()
    
    let columnWidth: CGFloat = 500
    
    @State private var isShowingLoginView = false
    @State private var isShowingSubscriptionDetails = false
    @State private var isShowingAlert = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
                    HStack(spacing: 16) {
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
                    Group {
                        subContinueButton
                        HStack {
                            Spacer()
                            Link("Integritetspolicy", destination: URL(string: "https://bartab-d48b2.web.app/privacypolicy.html")!)
                                .foregroundColor(.accentColor)
                            Text("och")
                            Link("Användarvillkor", destination: URL(string: "https://bartab-d48b2.web.app/termsandconditions.html")!)
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
                            Text("Prenumerationsdetaljer")
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
                                        alertTitle = "Återställningen misslyckades"
                                        alertMessage = "Ditt köp kunde inte återställas, inget giltigt kvitto kunde hittas."
                                        isShowingAlert = true
                                    } else {
                                        if let oldUserID = purchaserInfo?.originalAppUserId {
                                            paywallVM.transferData(from: oldUserID, to: newUserID)
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Återställ köp")
                        }
                        .alert(isPresented: $isShowingAlert) {
                            Alert(title: alertTitle, message: alertMessage, dismissButtonTitle: "OK")
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
        .onAppear {
            print(Auth.auth().currentUser?.uid ?? "Ingen inloggad")
        }
    }
}

// MARK: - Selling points view

private extension PaywallView {
    @ViewBuilder
    private var sellingPoints: some View {
        ContentRow(width: columnWidth,
                   headerText: "Håll enkelt koll",
                   bodyText: "Glöm bort manuella bonglistor och att räkna samman saldon efter varje träff. Med BarTab håller du och dina bargäster enkelt koll på saldoställningar.",
                   image: Image(systemName: "dollarsign.circle.fill"))
        ContentRow(width: columnWidth,
                   headerText: "Obegränsad bargästlista",
                   bodyText: "Lägg till obegränsat antal bargäster med automatiskt uppdaterande saldo och låt dem beställa från en dryckeslista som bara begränsas av ditt barskåp.",
                   image: Image(systemName: "person.2.circle.fill"))
        ContentRow(width: columnWidth,
                   headerText: "Maila aktuellt saldo",
                   bodyText: "Det ska vara enkelt att låta dina bargäster hålla koll på sitt saldo. Med ett knapptryck kan du skicka mail till varje gäst med deras aktuella saldo.",
                   image: Image(systemName: "envelope.fill"))
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
                    }
                }
            case .annual:
                guard let annualPackage = paywallVM.offerings?.annual else { return }
                return paywallVM.purchase(package: annualPackage) { completed in
                    if completed {
                        authentication.userAuthState = .subscribed
                    }
                }
            case .lifetime:
                guard let lifetimePackage = paywallVM.offerings?.lifetime else { return }
                return paywallVM.purchase(package: lifetimePackage) { completed in
                    if completed {
                        authentication.userAuthState = .subscribed
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
    }
    
    private var logoutButton: some View {
        Button {
            UserHandling.signOut { _ in }
        } label: {
            Text("Logga ut")
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
                    Text("\(offerings?.monthly?.localizedPriceString ?? "Price not found") / månad")
                        .fontWeight(.bold)
                    Text("Första veckan gratis!")
                        .font(.caption2)
                }
            case .annual:
                return VStack {
                    Text("\(offerings?.annual?.localizedPriceString ?? "Price not found") / år")
                        .fontWeight(.bold)
                    Text("Första veckan gratis!")
                        .font(.caption2)
                }
            case .lifetime:
                return VStack {
                    Text("\(offerings?.lifetime?.localizedPriceString ?? "Price not found")")
                        .fontWeight(.bold)
                    Text("Betala bara en gång!")
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
                        }
                    }
            }
        }
    }
}



// MARK: - Content rows for selling points

private extension PaywallView {
    struct ContentRow: View {
        let width: CGFloat
        let headerText: String
        let bodyText: String
        let image: Image
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(headerText)
                    .fontWeight(.black)
                Text(bodyText)
                    .fontWeight(.thin)
            }
            .frame(maxWidth: width, alignment: .leading)
            .padding()
            .overlay(alignment: .topLeading) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.horizontal, 20)
                    .offset(x: -(width * 0.1), y: width * 0.04)
            }
        }
    }
}
