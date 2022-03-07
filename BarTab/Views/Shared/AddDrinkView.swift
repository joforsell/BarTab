//
//  AddDrinkView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-15.
//

import SwiftUI
import SwiftUIX

struct AddDrinkView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    
    @Binding var detailViewShown: DetailViewRouter
    
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
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 240, weight: .thin))
                        .padding(.bottom, 48)
                        .frame(maxWidth: geometry.size.width/2, maxHeight: geometry.size.height/2)
                
                    CustomInputView(title: "Name",
                                    image: "square.text.square.fill",
                                    editing: $editingName,
                                    text: $name,
                                    keybTag: 1)
                    
                    CustomInputView(title: "Price",
                                    image: "dollarsign.square.fill",
                                    editing: $editingPrice,
                                    text: $price,
                                    keybTag: 2)
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
                                detailViewShown = .none
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .overlay {
                                    Text("Create drink")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                }
                        }
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("The drink needs a name"), dismissButton: .default(Text("OK")))
                    }
                Spacer()
            }
            .center(.horizontal)
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}

