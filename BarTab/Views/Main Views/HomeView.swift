//
//  HomeView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    
    @Namespace var orderNamespace
    
    @State var viewState: ViewState = .main
    @State var tappedDrink: String?
    @State var flyToModal: Bool = false
    var isGeometryMatched: Bool { !flyToModal && tappedDrink != nil }
    
    var fourColumnGrid = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    var threeColumnGrid = [GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20)]
    
    var body: some View {
        ZStack {
            VStack {
                HeaderView(viewState: $viewState)
                    .frame(height: 134)
                switch viewState {
                case .main:
                    HStack {
                        ScrollView() {
                            LazyVGrid(columns: fourColumnGrid, spacing: 20) {
                                ForEach(drinkListVM.drinkVMs) { drinkVM in
                                    DrinkCardView(drinkVM: drinkVM)
                                        .onTapGesture {
                                            tappedDrink = drinkVM.id
                                            confirmationVM.selectedDrink = drinkVM
                                        }
                                        .aspectRatio(0.9, contentMode: .fit)
                                        .matchedGeometryEffect(id: drinkVM.id, in: orderNamespace, isSource: true)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                                                
                        CustomerListView()
                    }
                case .settings:
                    SettingsView()
                        .frame(width: UIScreen.main.bounds.width)
                        .transition(.move(edge: .bottom))
                        .cornerRadius(radius: 20, corners: .topLeft)
                        .cornerRadius(radius: 20, corners: .topRight)
                }
            }
            .background(
                Image("backgroundbar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(Color.black.opacity(0.5).blendMode(.overlay))
                    .ignoresSafeArea()
            )
            if tappedDrink != nil {
                ConfirmOrderView(drinkVM: confirmationVM.selectedDrink ?? ConfirmationViewModel.errorDrink, tappedDrink: $tappedDrink)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                    .matchedGeometryEffect(id: isGeometryMatched ? tappedDrink! : "", in: orderNamespace, isSource: false)
                    .onAppear { withAnimation { flyToModal = true } }
                    .onDisappear { flyToModal = false }
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
            }
        }
    }
}

enum ViewState {
    case main
    case settings
}

