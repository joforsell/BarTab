//
//  DrinkSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct DrinkSettingsView: View {
    @EnvironmentObject var drinkVM: DrinkViewModel
    
    @State var editMode: EditMode = .inactive
    @State private var showingAddDrinkView = false
    @State private var newPrice = ""
    
    var body: some View {
        VStack {
            List {
                ForEach($drinkVM.drinks) { $drink in
                    DrinkRow(drink: $drink)
                }
                .onDelete(perform: delete)
            }
            .sheet(isPresented: $showingAddDrinkView) {
                AddDrinkView()
                    .environmentObject(drinkVM)
            }
            .navigationTitle("Drycker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingAddDrinkView = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                        }

                        EditButton()
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            drinkVM.removeDrink(drinkVM.drinks[index].id!)
        }
        drinkVM.drinks.remove(atOffsets: offsets)
    }
}

struct DrinkRow: View {
    @Binding var drink: Drink
    
    var body: some View {
        NavigationLink(destination: DrinkSettingsDetailView(drink: $drink)) {
            HStack {
                Text(drink.name)
                Spacer()
//                if editMode == .active {
//                    TextField("Nytt pris", text: $newPrice, onCommit: {
//                        drinkVM.adjustPriceOf(drink: drink.id!, to: Int(newPrice) ?? 0)
//                    })
//                        .frame(maxWidth: UIScreen.main.bounds.width / 8)
//                        .padding(4)
//                        .overlay(
//                                    RoundedRectangle(cornerRadius: 4)
//                                        .stroke(Color.black, lineWidth: 1)
//                                )
//                    Image(systemName: "checkmark.circle.fill")
//                        .onTapGesture(perform: { drinkVM.adjustPriceOf(drink: drink.id!, to: Int(newPrice) ?? 0) })
//                }
                Text("\(drink.price) kr")
                    .frame(minWidth: UIScreen.main.bounds.width / 8, alignment: .trailing)
            }
        }
    }
}

struct DrinkSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkSettingsView()
    }
}
