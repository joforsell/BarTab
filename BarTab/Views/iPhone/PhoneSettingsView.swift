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
    @EnvironmentObject var settingsState: SettingsState
    @EnvironmentObject var detailViewState: DetailViewState
    
    @AppStorage("backgroundColorIntensity") var backgroundColorIntensity: ColorIntensity = .medium

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
                    settingsState.settingsTab = .bartender
                    detailViewState.detailView = .none
                } label: {
                    Image("bartender")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: routerButtonSize, height: routerButtonSize)
                        .padding(routerButtonPadding)
                        .background(settingsState.settingsTab == .bartender ? Color("AppBlue") : Color.clear)
                        .cornerRadius(routerButtonCornerRadius)
                }
                Button {
                    settingsState.settingsTab = .drinks
                    detailViewState.detailView = .none
                } label: {
                    Image("beer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: routerButtonSize, height: routerButtonSize)
                        .padding(routerButtonPadding)
                        .background(settingsState.settingsTab == .drinks ? Color("AppBlue") : Color.clear)
                        .cornerRadius(routerButtonCornerRadius)
                }
                Button {
                    settingsState.settingsTab = .customers
                    detailViewState.detailView = .none
                } label: {
                    Image(systemName: "person.2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: routerButtonSize, height: routerButtonSize)
                        .padding(routerButtonPadding)
                        .background(settingsState.settingsTab == .customers ? Color("AppBlue") : Color.clear)
                        .cornerRadius(routerButtonCornerRadius)
                }
            }
            ScrollView(showsIndicators: false) {
                switch settingsState.settingsTab {
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
            if settingsState.settingsTab == .drinks && showingButton {
                addDrinkButton
            } else if settingsState.settingsTab == .customers && showingButton {
                addCustomerButton
            }
        }
        .background(VisualEffectBlurView(blurStyle: .dark)
                        .ignoresSafeArea())
        .background(
            Image("backgroundbar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(backgroundColorIntensity.overlayColor)
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
            AddDrinkView()
                .clearModalBackground()
        }
    }
    
    @ViewBuilder
    private var drinkScrollList: some View {
        switch detailViewState.detailView {
        case .drink(let drinkVM):
            KeyboardAvoiding(with: avoider) {
                DrinkSettingsDetailView(drinkVM: drinkVM)
                    .transition(.move(edge: .trailing))
            }
        case .customer( _):
            EmptyView()
        case .none:
            VStack(spacing: 4) {
                ForEach($drinkListVM.drinkVMs.sorted { $0.wrappedValue.drink.name < $1.wrappedValue.drink.name }) { $drinkVM in
                    VStack(spacing: 0) {
                        DrinkRow(drinkVM: $drinkVM)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    showingButton = false
                                    detailViewState.detailView = .drink(drinkVM: drinkVM)
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
                    Text(Currency.display(Float(drinkVM.drink.price), with: userHandler.user))
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
        switch detailViewState.detailView {
        case .drink( _):
            EmptyView()
        case .customer(let customerVM):
            KeyboardAvoiding(with: avoider) {
                CustomerSettingsDetailView(customerVM: customerVM)
            }
            .transition(.move(edge: .trailing))
        case .none:
            VStack(spacing: 4) {
                ForEach($customerListVM.customerVMs.sorted { $0.wrappedValue.customer.name < $1.wrappedValue.customer.name }) { $customerVM in
                    VStack(spacing: 0) {
                        CustomerRow(customerVM: $customerVM)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    showingButton = false
                                    detailViewState.detailView = .customer(customerVM: customerVM)
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
        
        let rowHeight: CGFloat = 32
        var imageHeight: CGFloat {
            rowHeight * 1.2
        }
        
        var body: some View {
            HStack {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: imageHeight, height: imageHeight)
                    .background {
                        CacheableAsyncImage(url: $customerVM.profilePictureUrl, animation: .easeIn, transition: .opacity) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: imageHeight, height: imageHeight)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    }
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxHeight: imageHeight)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                            case .failure( _):
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(0.6)
                                    .frame(width: imageHeight, height: imageHeight)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                VStack(alignment: .leading) {
                    Text(customerVM.customer.name)
                        .font(.callout)
                        .fontWeight(.bold)
                    Text(Currency.display(Float(customerVM.customer.balance), with: userHandler.user))
                        .font(.footnote)
                        .foregroundColor(customerVM.balanceColor)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.2))
            }
            .foregroundColor(.white)
            .frame(height: rowHeight)
        }
    }
    
    private var bartenderView: some View {
        KeyboardAvoiding(with: avoider) {
            BartenderSettingsView()
        }
    }

}
