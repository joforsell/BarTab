//
//  HeaderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    
    @Binding var viewState: ViewState
    
    var body: some View {
        HStack {
            Image("beer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .padding()
            VStack(alignment: .leading) {
                Image("logotext")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top)
                Text(userHandler.user.association ?? "")
                    .foregroundColor(.gray)
                    .font(.largeTitle)
                    .offset(y: -10)
            }
            Spacer()
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
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
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(viewState: .constant(.main))
            .previewLayout(.sizeThatFits)
    }
}
