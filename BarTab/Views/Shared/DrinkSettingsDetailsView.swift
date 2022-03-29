//
//  DrinkSettingsDetailsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import Combine
import Introspect

struct DrinkSettingsDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    @Binding var drinkVM: DrinkViewModel
    @Binding var detailsViewShown: DetailViewRouter
    
    @State private var editingName = false
    @State private var editingPrice = false
    @State private var editingImage = false
    
    @State private var showError = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                Image(drinkVM.drink.image.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.accentColor)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            editingImage.toggle()
                        } label: {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 44)
                                .contentShape(Rectangle())
                            
                        }
                        .popover(isPresented: $editingImage) {
                            ImagePickerView(drinkVM: drinkVM)
                        }
                        .offset(x: 40)
                    }
                CustomInputView(title: "Name",
                                image: "square.text.square.fill",
                                editing: $editingName,
                                text: $drinkVM.name,
                                keyboardTag: 1,
                                autocapitalizationType: .words)
                
                CustomInputView(title: "Price",
                                image: "dollarsign.square.fill",
                                editing: $editingPrice,
                                text: $drinkVM.priceAsString,
                                keyboardTag: 2,
                                keyboardType: .decimalPad,
                                isNumberInput: true,
                                numberString: $drinkVM.priceAsString)
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .overlay(alignment: .trailing) {
                        Button {
                            showError.toggle()
                        } label: {
                            Image(systemName: "trash.square.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showError) {
                            Alert(title: Text("Delete drink"),
                                  message: Text("Are you sure you want to delete this drink?"),
                                  primaryButton: .default(Text("Cancel")),
                                  secondaryButton: .destructive(Text("Delete")) {
                                drinkListVM.removeDrink(drinkVM.drink)
                                detailsViewShown = .none
                            })
                        }
                    }
                }
                .padding(.top, 48)
                Spacer()
            }
            Spacer()
        }
        .overlay(alignment: .topLeading) {
            if isPhone() {
                Button {
                    withAnimation {
                        detailsViewShown = .none
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .contentShape(Rectangle().size(width: 40, height: 40))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}

