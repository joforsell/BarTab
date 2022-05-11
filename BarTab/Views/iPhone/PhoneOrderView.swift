//
//  PhoneOrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-02-26.
//

import SwiftUI

struct PhoneOrderView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    
    @AppStorage("backgroundColorIntensity") var backgroundColorIntensity: ColorIntensity = .medium
    
    @Namespace var orderNamespace
    
    @State var orderMultiple: Bool = false
    @State var orderList = [DrinkViewModel]()
    @State var tappedDrink: String?
    @State var flyToModal: Bool = false
    var isGeometryMatched: Bool { !flyToModal && tappedDrink != nil }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(uiImage: Bundle.main.icon ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                        .padding(8)
                    Text(userHandler.user.association ?? "BarTab")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                    Spacer()
                    Button {
                        withAnimation {
                            orderMultiple.toggle()
                            orderList.removeAll()
                        }
                    } label: {
                        Image(systemName: orderMultiple ? "rectangle.stack.fill.badge.plus" : "rectangle.stack.badge.plus")
                            .font(.title)
                            .opacity(orderMultiple ? 1 : 0.4)
                            .foregroundColor(.accentColor)
                    }
                }
                if orderMultiple {
                    if orderList.isEmpty {
                        Text("Tap the item you want to add to the order")
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 4) {
                                ForEach(orderList) { drinkVM in
                                    MultipleOrderCardView(orderList: $orderList, drinkVM: drinkVM)
                                        .frame(width: 80, height: 100)
                                }
                            }
                        }
                        .frame(height: 110)
                        .onChange(of: orderList.count) { _ in
                            if orderList.isEmpty {
                                withAnimation {
                                    orderMultiple = false
                                }
                            }
                        }
                    }
                }
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        let sortedList = drinkListVM.sortDrinks(drinkListVM.drinkVMs, by: userHandler.user.drinkSorting)
                        ForEach(sortedList) { drinkVM in
                            DrinkCardView(drinkVM: drinkVM)
                                .onTapGesture {
                                    withAnimation {
                                        if orderMultiple {
                                            orderList.append(drinkVM)
                                        } else {
                                            tappedDrink = drinkVM.id
                                            confirmationVM.selectedDrink = drinkVM
                                        }
                                    }
                                }
                                .aspectRatio(1.4, contentMode: .fit)
                                .matchedGeometryEffect(id: drinkVM.id, in: orderNamespace, isSource: true)
                                .environmentObject(customerListVM)
                                .environmentObject(drinkListVM)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.easeInOut, value: userHandler.user.drinkCardColumns)
                    .animation(.easeInOut, value: userHandler.user.drinkSorting)
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 10)
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
                    .matchedGeometryEffect(id: isGeometryMatched ? tappedDrink! : "", in: orderNamespace, isSource: false)
                    .onAppear { withAnimation { flyToModal = true } }
                    .onDisappear { flyToModal = false }
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                    .environmentObject(customerListVM)
                    .environmentObject(drinkListVM)
                    .environmentObject(userHandler)
                    .zIndex(3)
                    .padding(.bottom, 60)
            }
        }
    }
    
    private func dismissConfirmOrderView() {
        withAnimation {
            tappedDrink = nil
        }
    }
}
