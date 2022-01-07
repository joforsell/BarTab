//
//  OrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    // MARK: Logic for MatchedGeometryEffect
    @Namespace var orderNamespace
    
    // Set ID for MatchedGeometryEffect to that of the tapped drink.
    @State var tappedDrink: String?
    
    // Used to connect and (onAppear) disconnect IDs of drink card and modal view.
    @State var flyToModal: Bool = false
    
    // To check if geometry should be matched.
    var isGeometryMatched: Bool { !flyToModal && tappedDrink != nil }
    
        
        
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 120), spacing: 20), count: userHandler.user.drinkCardColumns), spacing: 270) {
                    ForEach(drinkListVM.drinkVMs) { drinkVM in
                        DrinkCardView(drinkVM: drinkVM)
                            .onTapGesture {
                                tappedDrink = drinkVM.id
                                confirmationVM.selectedDrink = drinkVM
                            }
                            .matchedGeometryEffect(id: drinkVM.id, in: orderNamespace, isSource: true)
                    }
                }
                .padding()
            }
            .overlay {
                if tappedDrink != nil {
                    ConfirmOrderView(drinkVM: confirmationVM.selectedDrink ?? ConfirmationViewModel.errorDrink, tappedDrink: $tappedDrink)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                        .matchedGeometryEffect(id: isGeometryMatched ? tappedDrink! : "", in: orderNamespace, isSource: false)
                        .onAppear { withAnimation { flyToModal = true } }
                        .onDisappear { flyToModal = false }
                }
            }
        }
    }
}
