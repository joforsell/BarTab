//
//  AddDrinkView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct AddDrinkView: View {
    @EnvironmentObject var drinkViewModel: DrinkListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var price = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                Text("Lägg till dryck")
                    .font(.largeTitle)
            }
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
            TextField("Namn", text: $name)
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.6)))
                .padding()
            TextField("Kostnad", text: $price)
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.6)))
                .keyboardType(.numberPad)
            Button(action: addDrink) {
                Text("Lägg till")
                    .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
                
    func addDrink() {
        drinkViewModel.addDrink(name: name, price: Int(price) ?? 0)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        AddDrinkView()
    }
}
