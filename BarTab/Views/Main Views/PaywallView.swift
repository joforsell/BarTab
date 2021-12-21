//
//  PaywallView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var userHandler: UserHandling
    
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
            VStack {
                Spacer()
                Image("beer")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .frame(width: columnWidth * 0.3)
                    .padding(.bottom, -40)
                Text("BarTab")
                    .foregroundColor(.accentColor)
                    .font(.system(size: columnWidth * 0.14, weight: .bold))
                Spacer()
                sellingPoints
                Spacer()
                subButton
                Text("Därefter 49 kr i månaden.*")
                    .font(.caption)
                Spacer()
                HStack(spacing: 2) {
                    Text("*Prenumerationsdetaljer")
                    Image(systemName: "chevron.up")
                        .font(.footnote)
                    Spacer()
                    Text("Återställ köp")
                }
                .frame(width: columnWidth * 0.5)
                .font(.caption2)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: columnWidth)
            .center(.horizontal)
        }
    }
}

// MARK: - Views as properties for grouping
private extension PaywallView {
    @ViewBuilder
    private var sellingPoints: some View {
        ContentRow(width: columnWidth,
                   headerText: "Obegränsad bargästlista",
                   bodyText: "Lägg till obegränsat antal bargäster med automatiskt uppdaterande saldo och låt dem beställa från en dryckeslista som bara begränsas av ditt barskåp.",
                   image: Image(systemName: "person.2.circle.fill"))
        ContentRow(width: columnWidth,
                   headerText: "Maila aktuellt saldo",
                   bodyText: "Det ska vara enkelt att låta dina bargäster hålla koll på sitt saldo. Med ett knapptryck kan du skicka mail till varje gäst med deras aktuella saldo.",
                   image: Image(systemName: "envelope.fill"))
        ContentRow(width: columnWidth,
                   headerText: "Koppla till RFID-brickor",
                   bodyText: "Har ditt sällskap personliga RFID-brickor och en RFID-läsare? Använd dem för att smidigt scanna vem som gör köpet.",
                   image: Image(systemName: "wave.3.right.circle.fill"))
    }
    
    private var subButton: some View {
        Button {
            userHandler.userAuthState = .signedIn
        } label: {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: columnWidth * 0.75, height: 60)
                .foregroundColor(.accentColor)
                .overlay {
                    Text("Starta en veckas provperiod gratis")
                        .foregroundColor(.white)
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
