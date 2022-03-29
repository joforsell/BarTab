//
//  PhoneSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-02-26.
//

import SwiftUI
import SwiftUIX

struct PhoneSettingsView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var avoider: KeyboardAvoider

    @State private var settingsShown: SettingsRouter = .drinks
    @State private var detailsShown: DetailViewRouter = .none
    @State private var showingUser = false
    @State private var showingAddDrinkView = false
    @State private var showingAddCustomerView = false
    @State private var showingButton = true
    
    private let routerButtonSize: CGFloat = 40
    private let routerButtonCornerRadius: CGFloat = 10
    private let routerButtonPadding: CGFloat = 8
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button {
                    settingsShown = .drinks
                    detailsShown = .none
                } label: {
                    Image("beer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: routerButtonSize, height: routerButtonSize)
                        .padding(routerButtonPadding)
                        .background(settingsShown == .drinks ? Color("AppBlue") : Color.clear)
                        .cornerRadius(routerButtonCornerRadius)
                }
                Button {
                    settingsShown = .customers
                    detailsShown = .none
                } label: {
                    Image(systemName: "person.2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: routerButtonSize, height: routerButtonSize)
                        .padding(routerButtonPadding)
                        .background(settingsShown == .customers ? Color("AppBlue") : Color.clear)
                        .cornerRadius(routerButtonCornerRadius)
                }
                Button {
                    settingsShown = .bartender
                    detailsShown = .none
                } label: {
                    Image("bartender")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: routerButtonSize, height: routerButtonSize)
                        .padding(routerButtonPadding)
                        .background(settingsShown == .bartender ? Color("AppBlue") : Color.clear)
                        .cornerRadius(routerButtonCornerRadius)
                }
            }
            ScrollView(showsIndicators: false) {
                switch settingsShown {
                case .drinks:
                    drinkScrollList
                        .padding(.bottom, 48)
                case .customers:
                    customerScrollList
                        .padding(.bottom, 48)
                case .bartender:
                    bartenderView
                        .padding(.bottom, 48)
                default:
                    drinkScrollList
                        .padding(.bottom, 48)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
            if settingsShown == .drinks && showingButton {
                addDrinkButton
            } else if settingsShown == .customers && showingButton {
                addCustomerButton
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark)
                        .ignoresSafeArea())
        .background(
            Image("backgroundbar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(Color.black.opacity(0.5).blendMode(.overlay))
                .ignoresSafeArea()
        )
    }
    
    private var addCustomerButton: some View {
        Button {
            showingAddCustomerView = true
        } label: {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .padding()
                .frame(width: 90)
        }
        .offset(y: -50)
        .sheet(isPresented: $showingAddCustomerView) {
            AddCustomerView()
                .clearModalBackground()
        }
    }
    
    private var addDrinkButton: some View {
        Button {
            showingAddDrinkView = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .padding()
                .frame(width: 84)
        }
        .offset(y: -50)
        .sheet(isPresented: $showingAddDrinkView) {
            AddDrinkView(detailViewShown: $detailsShown)
                .clearModalBackground()
        }
    }
    
    @ViewBuilder
    private var drinkScrollList: some View {
        switch detailsShown {
        case .drink(let drinkVM, let detailsViewShown):
            KeyboardAvoiding(with: avoider) {
                DrinkSettingsDetailView(drinkVM: drinkVM, detailsViewShown: detailsViewShown)
                    .transition(.move(edge: .trailing))
            }
        case .customer(_, _):
            EmptyView()
        case .none:
            VStack(spacing: 4) {
                ForEach($drinkListVM.drinkVMs) { $drinkVM in
                    VStack(spacing: 0) {
                        DrinkRow(drinkVM: $drinkVM)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    showingButton = false
                                    detailsShown = .drink(drinkVM: $drinkVM, detailsViewShown: $detailsShown)
                                }
                            }
                        Divider()
                            .padding(.top, 4)
                    }
                }
            }
            .onAppear {
                showingButton = true
            }
        }
    }
    
    private struct DrinkRow: View {
        @EnvironmentObject var userHandler: UserHandling
        @Binding var drinkVM: DrinkViewModel
        
        var body: some View {
            HStack {
                Image(drinkVM.drink.image.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.1)
                VStack(alignment: .leading) {
                    Text(drinkVM.drink.name)
                        .font(.callout)
                        .fontWeight(.bold)
                    Text(Currency.display(drinkVM.drink.price, with: userHandler.user))
                        .font(.footnote)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.2))
            }
            .foregroundColor(.white)
            .frame(height: 32)
        }
    }
    
    @ViewBuilder
    private var customerScrollList: some View {
        switch detailsShown {
        case .drink(_, _):
            EmptyView()
        case .customer(let customerVM, let detailsViewShown):
            KeyboardAvoiding(with: avoider) {
                CustomerSettingsDetailView(customerVM: customerVM, detailsViewShown: detailsViewShown)
            }
            .transition(.move(edge: .trailing))
        case .none:
            VStack(spacing: 4) {
                ForEach($customerListVM.customerVMs) { $customerVM in
                    VStack(spacing: 0) {
                        CustomerRow(customerVM: $customerVM)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    showingButton = false
                                    detailsShown = .customer(customerVM: $customerVM, detailsViewShown: $detailsShown)
                                }
                            }
                        Divider()
                            .padding(.top, 4)
                    }
                }
            }
            .onAppear {
                showingButton = true
            }
        }
    }
    
    private struct CustomerRow: View {
        @EnvironmentObject var userHandler: UserHandling
        @Binding var customerVM: CustomerViewModel
        
        var body: some View {
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.6)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    }
                VStack(alignment: .leading) {
                    Text(customerVM.customer.name)
                        .font(.callout)
                        .fontWeight(.bold)
                    Text(Currency.display(customerVM.customer.balance, with: userHandler.user))
                        .font(.footnote)
                        .foregroundColor(customerVM.balanceColor)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.2))
            }
            .foregroundColor(.white)
            .frame(height: 32)
        }
    }
    
    private var bartenderView: some View {
        KeyboardAvoiding(with: avoider) {
            BartenderSettingsView(settingsShown: $settingsShown)
        }
    }

}
