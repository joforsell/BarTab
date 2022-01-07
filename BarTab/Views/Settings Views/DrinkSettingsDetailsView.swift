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
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var drinkListVM: DrinkListViewModel
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
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 22)
                            }
                            .popover(isPresented: $editingImage) {
                                ImagePickerView(drinkVM: $drinkVM)
                            }
                            .offset(x: 40)
                        }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .bottom) {
                            TextField(drinkVM.drink.name,
                                      text: $drinkVM.drink.name,
                                      onEditingChanged: { editingChanged in
                                self.avoider.editingField = 1
                                if editingChanged {
                                    editingName = true
                                } else {
                                    editingName = false
                                } },
                                      onCommit: { editingName.toggle() }
                            )
                                .disableAutocorrection(true)
                                .font(.title3)
                            Spacer()
                        }
                        .offset(y: 4)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "square.text.square.fill")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.5)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Namn".uppercased())
                                .font(.caption2)
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .offset(y: -10)
                        }
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                    .addBorder(editingName ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                    .padding(.top, 48)
                    .avoidKeyboard(tag: 1)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .bottom) {
                            TextField("\(drinkVM.drink.price) kr",
                                      text: $drinkVM.priceAsString,
                                      onEditingChanged: { editingChanged in
                                self.avoider.editingField = 2
                                if editingChanged {
                                    editingPrice = true
                                } else {
                                    editingPrice = false
                                } }, onCommit: { editingPrice.toggle() }
                            )
                                .onReceive(Just(drinkVM.priceAsString)) { newValue in
                                    let filtered = newValue.filter { "01233456789".contains($0) }
                                    if filtered != newValue {
                                        self.drinkVM.priceAsString = filtered
                                    }
                                }
                                .font(.title3)
                            Spacer()
                        }
                        .offset(y: 4)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "dollarsign.square.fill")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.5)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Pris".uppercased())
                                .font(.caption2)
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .offset(y: -10)
                        }
                        
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                    .addBorder(editingPrice ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                    .avoidKeyboard(tag: 2)
                    
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
                                Alert(title: Text("Radera dryck"),
                                      message: Text("Är du säker på att du vill radera den här drycken?"),
                                      primaryButton: .default(Text("Avbryt")),
                                      secondaryButton: .destructive(Text("Radera")) {
                                    drinkListVM.removeDrink(drinkVM.id)
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
        }
}

