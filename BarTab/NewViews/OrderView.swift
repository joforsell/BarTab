//
//  OrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    
    @Namespace var orderNamespace
    
    @State var showConfirmationView = false
    @State var selectedDrink: DrinkViewModel?
    
    private var fourColumnGrid = [GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20), GridItem(.adaptive(minimum: 120), spacing: 20)]
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: fourColumnGrid, spacing: 270) {
                    ForEach(drinkListVM.drinkVMs) { drinkVM in
                        DrinkCardView(drinkVM: drinkVM, orderNamespace: orderNamespace)
                            .onTapGesture {
                                withAnimation {
                                    selectedDrink = drinkVM
                                    showConfirmationView = true
                                }
                            }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 10))
            if showConfirmationView {
                ConfirmOrderView(drinkVM: selectedDrink!, orderNamespace: orderNamespace, showConfirmationView: $showConfirmationView)
                    .onTapGesture {
                        withAnimation {
                            showConfirmationView = false
                            selectedDrink = nil
                        }
                    }
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
