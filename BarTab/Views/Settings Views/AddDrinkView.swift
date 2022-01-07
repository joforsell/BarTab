//
//  AddDrinkView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-15.
//

import SwiftUI
import SwiftUIX

struct AddDrinkView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var price = ""
    
    @State private var editingName = false
    @State private var editingPrice = false
    
    @State private var isShowingAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                KeyboardAvoiding(with: avoider) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 240, weight: .thin))
                        .padding(.bottom, 48)
                
                    CustomInputView(title: "Namn", image: "square.text.square.fill", editing: $editingName, text: $name, keybTag: 6)
                    
                    CustomInputView(title: "Pris", image: "dollarsign.square.fill", editing: $editingPrice, text: $price, keybTag: 7)
                }
                
                Color.clear
                    .frame(width: 300, height: 16)
                    .padding()
                    .overlay {
                        Button {
                            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                                isShowingAlert = true
                            } else {
                                drinkListVM.addDrink(name: name, price: Int(price) ?? 0)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .overlay {
                                    Text("Skapa dryck".uppercased())
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                        }
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("Drycken måste ha ett namn"), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
                    }
                Spacer()
            }
            .center(.horizontal)
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}

