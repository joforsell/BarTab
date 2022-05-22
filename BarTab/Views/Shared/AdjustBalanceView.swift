//
//  AdjustBalanceView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-20.
//

import SwiftUI

struct AdjustBalanceView: View {
    @EnvironmentObject var userHandler: UserHandling
    
    let currentBalance: Int
    var stringedBalance: String {
        let adjustedBalance = Float(currentBalance) / 100
        return Currency.display(adjustedBalance, with: userHandler.user)
    }
    
    @State var adding = true
    @State var balanceAdjustment = 0
    
    var body: some View {
        VStack {
            HStack {
                Text(stringedBalance)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .overlay(alignment: .topLeading) {
                Text("Current balance:")
                    .textCase(.uppercase)
                    .font(.footnote)
                    .offset(x: -20, y: -20)
            }
            .padding(.top, 48)
            HStack {
                Button {
                    adding = true
                } label: {
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "plus")
                            .font(.title2, weight: .bold)
                        Text("Add")
                            .font(.caption2)
                            .textCase(.uppercase)
                            .padding()
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(Color.lead).opacity(adding ? 0.5 : 0.2)
                    .addBorder(Color.lead.opacity(adding ? 1 : 0.5), width: adding ? 2 : 0, cornerRadius: 10)
                }
                Button {
                    adding = false
                } label: {
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "minus")
                            .font(.title2, weight: .bold)
                        Text("Subtract")
                            .font(.caption2)
                            .textCase(.uppercase)
                            .padding()
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(Color.deficit).opacity(!adding ? 0.5 : 0.2)
                    .addBorder(Color.deficit.opacity(!adding ? 1 : 0.5), width: !adding ? 2 : 0, cornerRadius: 10)
                }
            }
            .frame(width: 300)
            Spacer()
        }
    }
}
