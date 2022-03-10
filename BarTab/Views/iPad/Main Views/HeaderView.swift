//
//  HeaderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    @Binding var viewState: ViewState
    
    var body: some View {
        HStack {
            Image("beer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .padding()
            Image("logotext")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Spacer()
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(viewState == .settings ? .black : .accentColor)
                    .background(viewState == .settings ? Color.accentColor.cornerRadius(6) : Color.clear.cornerRadius(6))
                    .rotationEffect(.degrees(viewState == .main ? 0 : 180))
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            if viewState == .main {
                                confirmationVM.isShowingConfirmationView = false
                                viewState = .settings
                            } else {
                                viewState = .main
                            }
                        }
                    }
                Spacer()
            }
        }
        .background(Color.black.opacity(0.6))
        .overlay(alignment: .center) {
            Text(userHandler.user.association ?? "")
                .foregroundColor(.gray)
                .font(.system(size: 40))
        }
    }
}
