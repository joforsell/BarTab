//
//  CustomInputView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-20.
//

import SwiftUI

struct CustomInputView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    
    var title: LocalizedStringKey
    var image: String
    @Binding var editing: Bool
    @Binding var text: String
    var keybTag: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .bottom) {
                TextField("",
                          text: $text,
                          onEditingChanged: { editingChanged in
                    self.avoider.editingField = keybTag
                    if editingChanged {
                        withAnimation {
                            editing = true
                        }
                    } else {
                        withAnimation {
                            editing = false
                        }
                    } },
                          onCommit: {
                    withAnimation {
                        editing.toggle()
                    }
                }
                )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.title3)
                Spacer()
            }
            .offset(y: 4)
            .overlay(alignment: .trailing) {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
            }
            .overlay(alignment: .topLeading) {
                Text(title)
                    .font(.caption2)
                    .textCase(.uppercase)
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
        .addBorder(editing ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
        .avoidKeyboard(tag: keybTag)
    }
}
