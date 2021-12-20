//
//  UpdateTagView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-18.
//

import SwiftUI
import SwiftUIX

struct UpdateTagView: View {
    let customer: Customer
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "wave.3.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.3)
                        .padding()
                    HStack {
                        Text("Läs av RFID-bricka för att koppla till ")
                        Text("\(customer.name).")
                            .bold()
                    }
                    .font(.headline)
                    Spacer()
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}
