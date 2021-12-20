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
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    @State private var settingsShown: SettingsRouter = .none
    @State private var detailViewShown: DetailViewRouter = .none
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
        
    @State private var showError = false
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
                            
                            emailButton
                        }
                        .padding()
                        .background(Color(.black).opacity(0.5))
                        
                        switch settingsShown {
                        case .drinks:
                            DrinkSettingsView(geometry: geo, detailViewShown: $detailViewShown)
                        case .customers:
                            CustomerSettingsView(geometry: geo, detailViewShown: $detailViewShown)
                        case .user:
                            UserSettingsView()
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
        .alert(isPresented: $showError) {
            Alert(title: Text("Kunde inte göra mailutskick"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
        .toast(isPresented: $isShowingEmailConfirmation, dismissAfter: 6) {
            ToastView(systemImage: ("envelope.fill", .accentColor, 50), title: "Mailutskick sändes", subTitle: "Ett mail med aktuellt saldo skickades till användare med kopplad mailadress.")
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
    
    func oneDayHasElapsedSince(_ date: Date) -> Bool {
        let timeSinceLatestEmail = -latestEmail.timeIntervalSinceNow
        return timeSinceLatestEmail > 86400
    }
    
    var emailButton: some View {
        Button {
            if oneDayHasElapsedSince(latestEmail) {
                isShowingEmailConfirmation.toggle()
            } else {
                errorString = "Du kan inte göra mailutskick oftare än var 24:e timma."
                showError.toggle()
            }
        } label: {
            Image(systemName: "envelope.fill")
                .font(.largeTitle)
                .foregroundColor(oneDayHasElapsedSince(latestEmail) ? .accentColor : .accentColor.opacity(0.3))
        }
    }
    
    func emailButtonAction() {
        customerListVM.sendEmails(from: userHandler.user.association) { result in
            switch result {
            case .failure(let error):
                errorString = error.localizedDescription
                showError = true
            case .success( _):
                latestEmail = Date()
            }
        }
        latestEmail = Date()
        withAnimation {
            isShowingEmailConfirmation.toggle()
        }
    }
}

enum SettingsRouter {
    case drinks, customers, user, none
}

indirect enum DetailViewRouter {
    case drink(drinkVM: Binding<DrinkViewModel>, detailsViewShown: Binding<DetailViewRouter>)
    case customer(customerVM: Binding<CustomerViewModel>, detailsViewShown: Binding<DetailViewRouter>)
    case none
}
