//
//  HomeView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("backgroundbar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.2)
                .overlay(Color.black.opacity(0.5).blendMode(.overlay))
            VStack {
                HeaderView()
                    .frame(width: Constants.screenSizeWidth, height: 134)
                BodyView()
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
