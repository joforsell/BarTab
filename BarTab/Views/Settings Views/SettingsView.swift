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
    @State private var detailViewShown: DetailViewRouter = .none
    
    private let routerButtonSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            Image(systemName: "gear")
                .font(.system(size: 300))
                .foregroundColor(.accentColor)
                .opacity(0.05)
            GeometryReader { geo in
                ZStack {
                    HStack(spacing: 0) {
                        VStack(alignment: .center) {
                            HStack {
                                Button {
                                    if settingsShown == .drinks {
                                        settingsShown = .none
                                    } else {
                                        settingsShown = .drinks
                                    }
                                    detailViewShown = .none
                                } label: {
                                    Image("beer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .frame(width: routerButtonSize, height: routerButtonSize)
                            .padding()
                            .background(settingsShown == .drinks ? Color("AppBlue") : Color.clear)
                            .cornerRadius(10)

                            
                            Button {
                                if settingsShown == .customers {
                                    settingsShown = .none
                                } else {
                                    settingsShown = .customers
                                }
                                detailViewShown = .none
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.accentColor)
                            }
                            .frame(width: routerButtonSize, height: routerButtonSize)
                            .padding()
                            .background(settingsShown == .customers ? Color("AppBlue") : Color.clear)
                            .cornerRadius(10)

                            
                            Button {
                                if settingsShown == .user {
                                    settingsShown = .none
                                } else {
                                    settingsShown = .user
                                }
                                detailViewShown = .none
                            } label: {
                                Image("bartender")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.accentColor)
                            }
                            .frame(width: routerButtonSize, height: routerButtonSize)
                            .padding()
                            .background(settingsShown == .user ? Color("AppBlue") : Color.clear)
                            .cornerRadius(10)

                            Spacer()
                        }
                        .padding()
                        .background(Color(.black).opacity(0.5))
                        
                        switch settingsShown {
                        case .drinks:
                            DrinkSettingsView(geometry: geo, detailViewShown: $detailViewShown)
                        case .customers:
                            CustomerSettingsView(isShowingEmailSuccessToast: $isShowingEmailSuccessToast, geometry: geo, detailViewShown: $detailViewShown)
                        case .user:
                            UserSettingsView()
                        case .none:
                            EmptyView()
                        }
                        
                        switch detailViewShown {
                        case .drink(let drinkVM, let geometry):
                            DrinkSettingsDetailView(drinkVM: drinkVM, geometry: geometry)
                        case .customer(let customerVM, let geometry):
                            CustomerSettingsDetailView(customerVM: customerVM, geometry: geometry)
                        case .none:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}

enum SettingsRouter {
    case drinks, customers, user, none
}

enum DetailViewRouter {
    case drink(drinkVM: Binding<DrinkViewModel>, geometry: GeometryProxy)
    case customer(customerVM: Binding<CustomerViewModel>, geometry: GeometryProxy)
    case none
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
