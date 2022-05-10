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
                }
                if orderMultiple {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(orderList) { drinkVM in
                                MultipleOrderCardView(drinkVM: drinkVM)
                            }
                        }
                    }
                    .frame(height: 150)
                }
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        let sortedList = drinkListVM.sortDrinks(drinkListVM.drinkVMs, by: userHandler.user.drinkSorting)
                        ForEach(sortedList) { drinkVM in
                            DrinkCardView(drinkVM: drinkVM)
                                .onTapGesture {
                                    withAnimation {
                                        tappedDrink = drinkVM.id
                                        confirmationVM.selectedDrink = drinkVM
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
