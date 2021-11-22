//
//  DrinkSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct DrinkSettingsView: View {
    @EnvironmentObject var drinkVM: DrinkListViewModel
    
    @State var editMode: EditMode = .inactive
    @State private var showingAddDrinkView = false
    @State private var newPrice = ""
    
    var body: some View {
        VStack {
            List {
                ForEach($drinkVM.drinkVMs) { $drinkVM in
                    DrinkRow(drinkVM: $drinkVM)
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
                    Button(action: {
                        showingAddDrinkView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding(.horizontal)
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            drinkVM.removeDrink(drinkVM.drinkVMs[index].id)
        }
        drinkVM.drinkVMs.remove(atOffsets: offsets)
    }
}

struct DrinkRow: View {
    @Binding var drinkVM: DrinkViewModel
    
    var body: some View {
        NavigationLink(destination: DrinkSettingsDetailView(drinkVM: $drinkVM)) {
            HStack {
                Text(drinkVM.drink.name)
                Spacer()
                Text("\(drinkVM.drink.price) kr")
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
