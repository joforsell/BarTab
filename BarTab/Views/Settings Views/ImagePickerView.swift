//
//  ImagePickerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-18.
//

import SwiftUI

struct ImagePickerView: View {
    var drinkVM: DrinkViewModel
    
    var fourColumnGrid = Array(repeating: GridItem(.adaptive(minimum: 120), spacing: 20), count: 4)
    
    var body: some View {
        LazyVGrid(columns: fourColumnGrid) {
            ForEach(DrinkImage.allCases, id: \.self) { image in
                Button {
                    drinkVM.drink.image = image
                } label: {
                    Image(image.rawValue)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .opacity(drinkVM.drink.image == image ? 1 : 0.5)
                        .frame(height: 60)
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}

