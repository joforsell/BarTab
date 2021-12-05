//
//  HomeView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    
    @Namespace var orderNamespace
    
    var body: some View {
        ZStack {
            Image("backgroundbar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.2)
                .overlay(Color.black.opacity(0.5).blendMode(.overlay))
            VStack {
                HeaderView()
                    .frame(width: UIScreen.main.bounds.width, height: 134)
                BodyView(orderNamespace: orderNamespace)
            }
            if confirmationVM.isShowingConfirmationView {
                ConfirmOrderView(drinkVM: confirmationVM.selectedDrink!, orderNamespace: orderNamespace, showConfirmationView: $confirmationVM.isShowingConfirmationView)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                    .onTapGesture {
                        withAnimation {
                            confirmationVM.isShowingConfirmationView = false
                            confirmationVM.selectedDrink = nil
                        }
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CustomerListViewModel())
    }
}
