//
//  AddDrinkView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-15.
//

import SwiftUI

import SwiftUI

struct AddDrinkView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var price = ""
    
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image(systemName: "person.crop.circle.badge.plus")
                .foregroundColor(.accentColor)
                .font(.system(size: 240, weight: .thin))
            Spacer()
            Group {
                TextField("Namn", text: $name)
                    .disableAutocorrection(true)
                Rectangle()
                    .background(Color("AppBlue"))
                    .frame(height: 1)
                    .padding(.bottom)
                TextField("Pris", text: $price)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                Rectangle()
                    .background(Color("AppBlue"))
                    .frame(height: 1)
                    .padding(.bottom)
            }
            Button {
                if name.trimmingCharacters(in: .whitespaces).isEmpty {
                    isShowingAlert = true
                } else {
                    drinkListVM.addDrink(name: name, price: Int(price) ?? 0)
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 40)
                    .overlay(Text("OK").foregroundColor(.white))
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Drycken måste ha ett namn"), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
            }
            Spacer()
        }
        .padding(.horizontal, 160)
    }
}

