//
//  SettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import SwiftUIX

struct SettingsView: View {
    @State private var isShowingEmailSuccessToast = false
    @State private var settingsShown: SettingsRouter = .none
    
    private let routerButtonSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            VisualEffectBlurView(blurStyle: .dark)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Image(systemName: "gear")
                .font(.system(size: 300))
                .foregroundColor(.accentColor)
                .opacity(0.05)
            GeometryReader { geo in
                ZStack {
                    HStack {
                        VStack(alignment: .center) {
                            HStack {
                                Button {
                                    if settingsShown == .drinks {
                                        settingsShown = .none
                                    } else {
                                        settingsShown = .drinks
                                    }
                                    print(settingsShown)
                                } label: {
                                    Image("beer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .frame(width: routerButtonSize, height: routerButtonSize)
                            .padding()
                            .background(settingsShown == .drinks ? Color("AppSecBlue") : Color("AppBlue"))
                            .cornerRadius(10)

                            
                            Button {
                                if settingsShown == .users {
                                    settingsShown = .none
                                } else {
                                    settingsShown = .users
                                }
                                print(settingsShown)
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.accentColor)
                            }
                            .frame(width: routerButtonSize, height: routerButtonSize)
                            .padding()
                            .background(settingsShown == .users ? Color("AppSecBlue") : Color("AppBlue"))
                            .cornerRadius(10)

                            
                            Button {
                                if settingsShown == .bartender {
                                    settingsShown = .none
                                } else {
                                    settingsShown = .bartender
                                }
                                print(settingsShown)
                            } label: {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.accentColor)
                            }
                            .frame(width: routerButtonSize, height: routerButtonSize)
                            .padding()
                            .background(settingsShown == .bartender ? Color("AppSecBlue") : Color("AppBlue"))
                            .cornerRadius(10)

                            Spacer()
                        }
                        .padding()
                        .background(Color(.black).opacity(0.5))
                        switch settingsShown {
                        case .drinks:
                            DrinkSettingsView(geometry: geo)
                        case .users:
                            CustomerSettingsView(isShowingEmailSuccessToast: $isShowingEmailSuccessToast)
                                .frame(width: geo.size.width * 0.2)
                        case .bartender:
                            UserSettingsView()
                                .frame(width: geo.size.width * 0.2)
                        case .none:
                            EmptyView()
                        }
                    }
                }
                .frame(width: geo.size.width * 0.15)
            }
        }
    }
}

enum SettingsRouter {
    case drinks, users, bartender, none
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
