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
    
    @State private var settingsShown: SettingsRouter = .drinks
    @State private var detailViewShown: DetailViewRouter = .none
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
    
    @State private var showError = false
    @State private var confirmEmails = false
    @State private var errorTitle = ""
    @State private var errorString = ""
    @State private var isShowingEmailConfirmation = false
    
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
                                        Image(systemName: "person.2")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.accentColor)
                                    }
                                    .frame(width: routerButtonSize, height: routerButtonSize)
                                    .padding()
                                    .background(settingsShown == .customers ? Color("AppBlue") : Color.clear)
                                    .cornerRadius(10)
                                    
                                    
                                    Button {
                                        if settingsShown == .bartender {
                                            settingsShown = .none
                                        } else {
                                            settingsShown = .bartender
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
                                    .background(settingsShown == .bartender ? Color("AppBlue") : Color.clear)
                                    .cornerRadius(10)
                                    
                                    Spacer()
                                    
                                    emailButton
                                        .alert(errorTitle, isPresented: $showError) {
                                            Button("Cancel") {
                                                showError = false
                                            }
                                            AsyncButton(action: {
                                                await emailButtonAction()
                                            }, label: {
                                                Text("OK")
                                            })
                                        }
                                    
                                }
                                .padding()
                                .background(Color(.black).opacity(0.5))
                                
                                switch settingsShown {
                                case .drinks:
                                    DrinkSettingsView(geometry: geo, detailViewShown: $detailViewShown)
                                case .customers:
                                    CustomerSettingsView(geometry: geo, detailViewShown: $detailViewShown)
                                case .bartender:
                                    BartenderSettingsView(settingsShown: $settingsShown)
                                case .user:
                                    withAnimation {
                                        UserSettingsView(settingsShown: $settingsShown)
                                            .transition(.move(edge: .bottom))
                                    }
                                case .none:
                                    EmptyView()
                                }
                                
                                switch detailViewShown {
                                case .drink(let drinkVM, let detailsViewShown):
                                    DrinkSettingsDetailView(drinkVM: drinkVM, detailsViewShown: detailsViewShown)
                                case .customer(let customerVM, let detailsViewShown):
                                    CustomerSettingsDetailView(customerVM: customerVM, detailsViewShown: detailsViewShown)
                                case .none:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }
            .toast(isPresented: $isShowingEmailConfirmation, dismissAfter: 6, onDismiss: { isShowingEmailConfirmation = false }) {
                ToastView(systemImage: ("envelope.fill", .accentColor, 50), title: "E-mail(s) sent", subTitle: "An e-mail showing current balance was sent to each bar guest with an associated e-mail address.")
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
                if oneDayHasElapsedSince(latestEmail) {
                    errorTitle = "Are you sure you want to send e-mail(s)?"
                    errorString = "This will send an e-mail showing current balance to each bar guest with an associated e-mail address."
                } else {
                    errorTitle = "Could not send"
                    errorString = "You can only send e-mail(s) once every minute."
                }
                showError = true
            } label: {
                Image(systemName: "envelope.fill")
                    .font(.largeTitle)
                    .foregroundColor(oneDayHasElapsedSince(latestEmail) ? .accentColor : .accentColor.opacity(0.3))
            }
        }
    
        
        func emailButtonAction() async {
            var customers = [Customer]()
            customerListVM.customerVMs.forEach { customerVM in
                customers.append(customerVM.customer)
            }
            do {
//                try await customerListVM.sendEmails(from: userHandler.user, to: customers)
                latestEmail = Date()
                withAnimation {
                    isShowingEmailConfirmation.toggle()
                }
            } catch {
                errorTitle = "Error sending emails"
                errorString = error.localizedDescription
                showError = true
            }
        }
}

enum SettingsRouter {
    case drinks, customers, bartender, user, none
}

indirect enum DetailViewRouter {
    case drink(drinkVM: Binding<DrinkViewModel>, detailsViewShown: Binding<DetailViewRouter>)
    case customer(customerVM: Binding<CustomerViewModel>, detailsViewShown: Binding<DetailViewRouter>)
    case none
}
