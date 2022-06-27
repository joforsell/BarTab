//
//  HomeView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI
import SwiftUIX
import Firebase

struct HomeView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @StateObject var drinkListVM = DrinkListViewModel(userHandler: UserHandling())
    @StateObject var customerListVM = CustomerListViewModel()
    @StateObject var userHandler = UserHandling()
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @StateObject var orientationInfo = OrientationInfo()
    
    @AppStorage("backgroundColorIntensity") var backgroundColorIntensity: ColorIntensity = .medium

    @Namespace var orderNamespace
    
    @State var orderMultiple: Bool = false
    @State var orderList = [OrderViewModel]()
    
    @State var viewState: ViewState = .main
    @State var tappedDrink: String?
    @State var flyToModal: Bool = false
    var isGeometryMatched: Bool { !flyToModal && tappedDrink != nil }
        
    var body: some View {
        ZStack {
            VStack {
                HeaderView(viewState: $viewState, orderList: $orderList, orderMultiple: $orderMultiple, tappedDrink: $tappedDrink, orderNamespace: orderNamespace)
                    .environmentObject(userHandler)
                    .frame(height: 134)
                switch viewState {
                case .main:
                    HStack {
                        VStack {
                            if orderMultiple {
                                if orderList.isEmpty {
                                    Text("Tap the item you want to add to the order")
                                        .font(.title)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(alignment: .center, spacing: 4) {
                                            ForEach(orderList) { orderVM in
                                                MultipleOrderCardView(orderList: $orderList, orderVM: orderVM)
                                                    .frame(width: 120, height: 150)
                                                    .environmentObject(userHandler)
                                            }
                                        }
                                    }
                                    .frame(height: 160)
                                }
                            }
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: userHandler.user.drinkCardColumns), spacing: 20) {
                                    let sortedList = drinkListVM.sortDrinks(drinkListVM.drinkVMs, by: userHandler.user.drinkSorting)
                                    ForEach(sortedList) { drinkVM in
                                        DrinkCardView(drinkVM: drinkVM)
                                            .onTapGesture {
                                                withAnimation {
                                                    if orderMultiple {
                                                        orderList.insert(OrderViewModel(drinkVM.drink), at: 0)
                                                    } else {
                                                        tappedDrink = drinkVM.id
                                                        confirmationVM.selectedDrink = drinkVM
                                                    }
                                                }
                                            }
                                            .aspectRatio(0.9, contentMode: .fit)
                                            .matchedGeometryEffect(id: drinkVM.id, in: orderNamespace, isSource: true)
                                            .environmentObject(customerListVM)
                                            .environmentObject(drinkListVM)
                                            .environmentObject(userHandler)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .animation(.easeInOut, value: userHandler.user.drinkCardColumns)
                                .animation(.easeInOut, value: userHandler.user.drinkSorting)
                            }
                        }
                                                
                        CustomerListView()
                            .environmentObject(customerListVM)
                            .environmentObject(userHandler)

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
                    .overlay(backgroundColorIntensity.overlayColor)
                    .ignoresSafeArea()
            )
            if tappedDrink != nil {
                ConfirmOrderView(drinkVM: confirmationVM.selectedDrink ?? ConfirmationViewModel.errorDrink,
                                 tappedDrink: tappedDrink,
                                 orderList: $orderList,
                                 orderMultiple: $orderMultiple,
                                 pct: flyToModal ? 1 : 0,
                                 onClose: dismissConfirmOrderView)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                    .matchedGeometryEffect(id: isGeometryMatched ? tappedDrink! : "", in: orderNamespace, isSource: false)
                    .onAppear { flyToModal = true }
                    .onDisappear { flyToModal = false }
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                    .animation(.easeInOut, value: flyToModal)
                    .environmentObject(customerListVM)
                    .environmentObject(drinkListVM)
                    .environmentObject(userHandler)
                    .zIndex(3)
            }
        }
    }
    
    var updateView: some View {
        VStack {
            Spacer()
            HStack {
            Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
            Spacer()
            }
            Spacer()
        }
        .background(VisualEffectBlurView(blurStyle: .dark)
                        .ignoresSafeArea())
    }
    
    private func dismissConfirmOrderView() {
        withAnimation {
            tappedDrink = nil
        }
    }
}

enum ViewState {
    case main
    case settings
}


