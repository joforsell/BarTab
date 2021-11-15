//
//  SettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct SettingsView: View {
    @State private var isShowingEmailSuccessToast = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    NavigationLink(destination: DrinkSettingsView()) {
                        Text("Drycker")
                    }
                    NavigationLink(destination: CustomerSettingsView(isShowingEmailSuccessToast: $isShowingEmailSuccessToast)) {
                        Text("Medlemmar")
                    }
                    NavigationLink(destination: UserSettingsView()) {
                        Text("Användare")
                    }
                }
                .navigationTitle("Inställningar")
            }
            if isShowingEmailSuccessToast {
                VStack {
                    HStack(alignment: .top) {
                        ToastView(systemImage: ("envelope.fill", Color("AppYellow"), 50), title: "Mail skickades", subTitle: "Nuvarande saldo skickades till samtliga kunder.")
                    }
                    Spacer()
                }
                .transition(.move(edge: .top))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            isShowingEmailSuccessToast = false
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SettingsView()
                .previewInterfaceOrientation(.landscapeRight)
            DrinkSettingsView()
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            SettingsView()
        }
    }
}
