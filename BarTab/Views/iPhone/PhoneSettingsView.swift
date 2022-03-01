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
                case .customers:
                    customerScrollList
                case .bartender:
                    bartenderView
                default:
                    drinkScrollList
                }
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
    
    @ViewBuilder
    private var drinkScrollList: some View {
        switch detailsShown {
        case .drink(let drinkVM, let detailsViewShown):
            KeyboardAvoiding(with: avoider) {
                DrinkSettingsDetailView(drinkVM: drinkVM, detailsViewShown: detailsViewShown)
            }
            .transition(.move(edge: .trailing))
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
                                    detailsShown = .drink(drinkVM: $drinkVM, detailsViewShown: $detailsShown)
                                }
                            }
                        Divider()
                            .padding(.top, 4)
                    }
                }
            }
        }
    }
    
    private struct DrinkRow: View {
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
                    Text("\(drinkVM.drink.price) kr")
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
    
    private var customerScrollList: some View {
        VStack(spacing: 4) {
            ForEach($customerListVM.customerVMs) { $customerVM in
                VStack(spacing: 0) {
                    CustomerRow(customerVM: $customerVM)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.clear)
                        .contentShape(Rectangle())
                    Divider()
                        .padding(.top, 4)
                }
            }
        }
    }
    
    private struct CustomerRow: View {
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
                    Text("\(customerVM.customer.balance) kr")
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
