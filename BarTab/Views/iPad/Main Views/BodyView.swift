////
////  BodyView.swift
////  BarTab
////
////  Created by Johan Forsell on 2021-11-30.
////
//
//import SwiftUI
//
//struct BodyView: View {
//    @Binding var viewState: ViewState
//
//    var body: some View {
//        Group {
//            switch viewState {
//            case .main:
//                HStack {
//                    OrderView()
//                    CustomerListView()
//                }
//            case .settings:
//                SettingsView()
//                    .frame(width: UIScreen.main.bounds.width)
//                    .transition(.move(edge: .bottom))
//            }
//        }
//    }
//}
