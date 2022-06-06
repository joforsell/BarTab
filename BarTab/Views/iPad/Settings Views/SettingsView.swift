//
//  SettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import SwiftUIX
import ToastUI

struct SettingsView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var settingsState: SettingsState
    @EnvironmentObject var detailViewState: DetailViewState
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
    
    @State private var showError = false
    @State private var confirmEmails = false
    @State private var errorTitle = ""
    @State private var errorString = ""
    @State private var isShowingEmailConfirmation = false
    @State private var presentingEmailView = false

    
    private let routerButtonSize: CGFloat = 60
    
    var body: some View {
            ZStack {
                Image(systemName: "gear")
                    .font(.system(size: 300))
                    .foregroundColor(.accentColor)
                    .opacity(0.05)
                GeometryReader { geo in
                    ZStack {
                        KeyboardAvoiding(with: avoider) {
                            HStack(spacing: 0) {
                                VStack(alignment: .center) {
                                    Button {
                                        if settingsState.settingsTab == .bartender {
                                            settingsState.settingsTab = .none
                                        } else {
                                            settingsState.settingsTab = .bartender
                                        }
                                        detailViewState.detailView = .none
                                    } label: {
                                        Image("bartender")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.accentColor)
                                    }
                                    .frame(width: routerButtonSize, height: routerButtonSize)
                                    .padding()
                                    .background(settingsState.settingsTab == .bartender ? Color("AppBlue") : Color.clear)
                                    .cornerRadius(10)

                                    Button {
                                        if settingsState.settingsTab == .drinks {
                                            settingsState.settingsTab = .none
                                        } else {
                                            settingsState.settingsTab = .drinks
                                        }
                                        detailViewState.detailView = .none
                                    } label: {
                                        Image("beer")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.accentColor)
                                    }
                                    .frame(width: routerButtonSize, height: routerButtonSize)
                                    .padding()
                                    .background(settingsState.settingsTab == .drinks ? Color("AppBlue") : Color.clear)
                                    .cornerRadius(10)
                                    
                                    
                                    Button {
                                        if settingsState.settingsTab == .customers {
                                            settingsState.settingsTab = .none
                                        } else {
                                            settingsState.settingsTab = .customers
                                        }
                                        detailViewState.detailView = .none
                                    } label: {
                                        Image(systemName: "person.2")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.accentColor)
                                    }
                                    .frame(width: routerButtonSize, height: routerButtonSize)
                                    .padding()
                                    .background(settingsState.settingsTab == .customers ? Color("AppBlue") : Color.clear)
                                    .cornerRadius(10)
                                    
                                    Spacer()
                                    
                                    emailButton                                    
                                }
                                .padding()
                                .background(Color(.black).opacity(0.5))
                                
                                switch settingsState.settingsTab {
                                case .drinks:
                                    DrinkSettingsView(geometry: geo)
                                case .customers:
                                    CustomerSettingsView(geometry: geo)
                                case .bartender:
                                    BartenderSettingsView()
                                case .user:
                                    withAnimation {
                                        UserSettingsView()
                                            .transition(.move(edge: .bottom))
                                    }
                                case .none:
                                    EmptyView()
                                }
                                
                                switch detailViewState.detailView {
                                case .drink(let drinkVM):
                                    DrinkSettingsDetailView(drinkVM: drinkVM)
                                case .customer(let customerVM):
                                    CustomerSettingsDetailView(customerVM: customerVM)
                                case .none:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $presentingEmailView) {
                        BalanceUpdateEmailView(presenting: $presentingEmailView)
                            .clearModalBackground()
                    }

                }
            }
            .toast(isPresented: $isShowingEmailConfirmation, dismissAfter: 6, onDismiss: { isShowingEmailConfirmation = false }) {
                ToastView(systemImage: ("envelope.fill", .accentColor, 50), title: "E-mail(s) sent", subTitle: "An e-mail showing current balance was sent to the chosen bar guests.")
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .ignoresSafeArea(.keyboard)
        }
        
        func oneDayHasElapsedSince(_ date: Date) -> Bool {
            let timeSinceLatestEmail = -latestEmail.timeIntervalSinceNow
            return timeSinceLatestEmail > 60
        }
        
        var emailButton: some View {
            Button {
                withAnimation {
                    presentingEmailView = true
                }
            } label: {
                Image(systemName: "envelope.fill")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
            }
        }
}
