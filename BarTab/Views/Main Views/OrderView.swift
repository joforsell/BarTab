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
    
    @Namespace var orderNamespace
    @State var tappedDrink: String?
    @State var flyToModal: Bool = false
    var isGeometryMatched: Bool { !flyToModal && tappedDrink != nil }
        
    var fourColumnGrid = [GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20)]
    var threeColumnGrid = [GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20)]
        
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: fourColumnGrid, spacing: 270) {
                    ForEach(drinkListVM.drinkVMs) { drinkVM in
                        DrinkCardView(drinkVM: drinkVM)
                            .onTapGesture {
                                tappedDrink = drinkVM.id
                                confirmationVM.selectedDrink = drinkVM
                            }
                            .matchedGeometryEffect(id: drinkVM.id, in: orderNamespace, isSource: true)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 10))
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
