//
//  PaywallView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import SwiftUI
import Purchases

struct PaywallView: View {
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var paywallVM = PaywallViewModel()
    
    let columnWidth: CGFloat = 500
    
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
                        #warning("Remove before deploying")
                        Button("Bypass paywall (for beta)") { authentication.userAuthState = .signedIn }
                        .foregroundColor(.red)
                            .padding(.bottom, 48)
                        Spacer()
                    }
                    HStack(spacing: 2) {
                        Text("Prenumerationsdetaljer")
                        Image(systemName: "chevron.up")
                            .font(.footnote)
                        Spacer()
                        Text("Återställ köp")
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
                   headerText: "Håll enkelt koll",
                   bodyText: "Glöm bort manuella bånglistor och att räkna samman saldon efter varje träff. Med BarTab håller du och dina bargäster enkelt koll på saldoställningar.",
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
    
// MARK: - Sub button views
    
    private var subContinueButton: some View {
        Button {
            switch paywallVM.selectedSub {
            case .monthly:
                guard let monthlyPackage = paywallVM.offerings?.monthly else { return }
                return paywallVM.purchase(package: monthlyPackage) { completed in
                    if completed {
                        authentication.userAuthState = .signedIn
                    }
                }
            case .annual:
                guard let annualPackage = paywallVM.offerings?.annual else { return }
                return paywallVM.purchase(package: annualPackage) { completed in
                    if completed {
                        authentication.userAuthState = .signedIn
                    }
                }
            case .lifetime:
                guard let lifetimePackage = paywallVM.offerings?.monthly else { return }
                return paywallVM.purchase(package: lifetimePackage) { completed in
                    if completed {
                        authentication.userAuthState = .signedIn
                    }
                }
            }
        } label: {
            RoundedRectangle(cornerRadius: 6)
                .frame(height: 80)
                .foregroundColor(.accentColor)
                .overlay {
                    VStack {
                        Text("Starta en veckas provperiod gratis")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(2)
                        ContinueButtonText(selectedSub: $paywallVM.selectedSub, offerings: paywallVM.offerings)
                    }
                }
        }
        .padding(.vertical)
        .padding(.top)
    }
    
    struct ContinueButtonText: View {
        @Binding var selectedSub: PaywallViewModel.Subscription
        let offerings: Purchases.Offering?
        
        var body: some View {
            switch selectedSub {
            case .monthly:
                return Text("Sedan \(offerings?.monthly?.localizedPriceString ?? "") / månad")
            case .annual:
                return Text("Sedan \(offerings?.annual?.localizedPriceString ?? "") / år")
            case .lifetime:
                return Text("Sedan en engångsavgift på \(offerings?.lifetime?.localizedPriceString ?? "")")
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
                            Text(package?.localizedPriceString ?? "")
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


// MARK: - Background shape for darkening part of background
private extension PaywallView {
    struct BackgroundBlob: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: -0.00096*width, y: 0))
            path.addLine(to: CGPoint(x: -0.00096*width, y: 0.99819*height))
            path.addLine(to: CGPoint(x: 1.00266*width, y: 1.00096*height))
            path.addCurve(to: CGPoint(x: 0.72457*width, y: 0.60832*height), control1: CGPoint(x: 1.00266*width, y: 1.00096*height), control2: CGPoint(x: 0.95695*width, y: 0.70292*height))
            path.addCurve(to: CGPoint(x: 0.58216*width, y: 0.37605*height), control1: CGPoint(x: 0.66684*width, y: 0.58481*height), control2: CGPoint(x: 0.58531*width, y: 0.46194*height))
            path.addCurve(to: CGPoint(x: 0.3339*width, y: 0.00138*height), control1: CGPoint(x: 0.576*width, y: 0.20834*height), control2: CGPoint(x: 0.48146*width, y: 0.00138*height))
            path.addCurve(to: CGPoint(x: -0.00096*width, y: 0), control1: CGPoint(x: 0.1991*width, y: 0.00138*height), control2: CGPoint(x: -0.00096*width, y: 0))
            path.closeSubpath()
            return path
        }
    }
}
