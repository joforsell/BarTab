//
//  HomeView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @StateObject var drinkListVM = DrinkListViewModel()
    @StateObject var customerListVM = CustomerListViewModel()
    @StateObject var userHandler = UserHandling()
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @StateObject var orientationInfo = OrientationInfo()
    
    @Namespace var orderNamespace
    
    @State var viewState: ViewState = .main
    @State var tappedDrink: String?
    @State var flyToModal: Bool = false
    var isGeometryMatched: Bool { !flyToModal && tappedDrink != nil }
        
    var body: some View {
        ZStack {
            VStack {
                HeaderView(viewState: $viewState)
                    .environmentObject(userHandler)
                    .frame(height: 134)
                switch viewState {
                case .main:
                    HStack {
                        ScrollView() {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: userHandler.user.drinkCardColumns), spacing: 20) {
                                let sortedList = drinkListVM.sortDrinks(drinkListVM.drinkVMs, by: userHandler.user.drinkSorting)
                                ForEach(sortedList) { drinkVM in
                                    DrinkCardView(drinkVM: drinkVM)
                                        .onTapGesture {
                                            tappedDrink = drinkVM.id
                                            confirmationVM.selectedDrink = drinkVM
                                        }
                                        .aspectRatio(0.9, contentMode: .fit)
                                        .matchedGeometryEffect(id: drinkVM.id, in: orderNamespace, isSource: true)
                                        .environmentObject(customerListVM)
                                        .environmentObject(drinkListVM)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .animation(.easeInOut)
                        }
                                                
                        CustomerListView()
                            .environmentObject(customerListVM)

                    }
                    .padding(.leading)
                case .settings:
                    SettingsView()
                        .frame(width: UIScreen.main.bounds.width)
                        .transition(.move(edge: .bottom))
                        .cornerRadius(radius: 20, corners: .topLeft)
                        .cornerRadius(radius: 20, corners: .topRight)
                        .environmentObject(drinkListVM)
                        .environmentObject(customerListVM)
                        .environmentObject(userHandler)
                }
            }
            .overlay(alignment: .bottomLeading) {
                if viewState == .main {
                    Menu {
                        Menu {
                            Picker(selection: $userHandler.user.drinkSorting, label: Text("Sort")) {
                                ForEach(DrinkListViewModel.DrinkSorting.allCases, id: \.self) { sorting in
                                    Text(sorting.description)
                                        .foregroundColor(userHandler.user.drinkSorting == sorting ? .accentColor : .black)
                                }
                            }
                            .onChange(of: userHandler.user.drinkSorting) { sorting in
                                userHandler.updateDrinkSorting(sorting)
                            }
                        } label: {
                            Label("Sort", systemImage: "arrow.left.arrow.right.circle")
                        }
                        Menu {
                            Picker("Drinks per row", selection: $userHandler.user.drinkCardColumns) {
                                Text("2").tag(2)
                                Text("3").tag(3)
                                Text("4").tag(4)
                                Text("5").tag(5)
                                Text("6").tag(6)
                            }
                            .onChange(of: userHandler.user.drinkCardColumns) { columnCount in
                                userHandler.updateColumnCount(columnCount)
                            }
                        } label: {
                            Label("Drinks per row", systemImage: orientationInfo.orientation == .landscape ? "apps.ipad.landscape" : "apps.ipad")
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                            .padding()
                            .frame(width: 80)
                    }
                    .transition(.move(edge: .leading))
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
                ConfirmOrderView(drinkVM: confirmationVM.selectedDrink ?? ConfirmationViewModel.errorDrink, tappedDrink: tappedDrink, pct: flyToModal ? 1 : 0, onClose: dismissConfirmOrderView)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                    .matchedGeometryEffect(id: isGeometryMatched ? tappedDrink! : "", in: orderNamespace, isSource: false)
                    .onAppear { withAnimation { flyToModal = true } }
                    .onDisappear { flyToModal = false }
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .environmentObject(customerListVM)
                    .environmentObject(drinkListVM)
                    .environmentObject(userHandler)
            }
        }
    }
    
    private func dismissConfirmOrderView() {
        tappedDrink = nil
    }
}

enum ViewState {
    case main
    case settings
}

