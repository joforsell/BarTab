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
    
    var orderNamespace: Namespace.ID
        
    var fourColumnGrid = [GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20)]
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: fourColumnGrid, spacing: 270) {
                    ForEach(drinkListVM.drinkVMs) { drinkVM in
                        DrinkCardView(drinkVM: drinkVM, orderNamespace: orderNamespace)
                            .onTapGesture {
                                withAnimation {
                                    confirmationVM.selectedDrink = drinkVM
                                    confirmationVM.isShowingConfirmationView = true
                                }
                            }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 10))
        }
    }
}
