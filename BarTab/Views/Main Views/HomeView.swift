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
    
    @State var viewState: ViewState = .main
    
    var body: some View {
        ZStack {
            Image("backgroundbar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.2)
                .overlay(Color.black.opacity(0.5).blendMode(.overlay))
            VStack {
                HeaderView(viewState: $viewState)
                    .frame(width: UIScreen.main.bounds.width, height: 134)
                BodyView(viewState: $viewState, orderNamespace: orderNamespace)
            }
            if confirmationVM.isShowingConfirmationView {
                ConfirmOrderView(drinkVM: confirmationVM.selectedDrink ?? confirmationVM.errorDrink, orderNamespace: orderNamespace)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
            }
//            if confirmationVM.isShowingPurchaseConfirmedToast {
//                VStack {
//                    HStack(alignment: .top) {
//                        ToastView(systemImage: ("checkmark.circle.fill", .accentColor, 50), title: "Ditt köp slutfördes", subTitle: "\(customerListVM.customerWithKey(confirmationVM.tagKey)) köpte \(confirmationVM.selectedDrink?.drink.name ?? "Saknas") för \(confirmationVM.selectedDrink?.drink.price ?? 0) kr.")
//                    }
//                    Spacer()
//                }
//                .transition(.move(edge: .top))
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                        withAnimation {
//                            confirmationVM.isShowingPurchaseConfirmedToast = false
//                        }
//                    }
//                }
//                .zIndex(10)
//            }

        }
    }
}

enum ViewState {
    case main
    case settings
}

