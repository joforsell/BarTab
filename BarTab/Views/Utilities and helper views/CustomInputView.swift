//
//  CustomInputView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-20.
//

import SwiftUI
import UIKit
import Combine

struct CustomInputView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    
    var title: LocalizedStringKey
    var image: String
    @Binding var editing: Bool
    @Binding var text: String
    var keyboardTag: Int
    var keyboardType: UIKeyboardType = .default
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var disablingAutocorrection: Bool = true
    var isNumberInput: Bool = false
    var onCommit: () -> Void
    
    init(title: LocalizedStringKey, image: String, editing: Binding<Bool>, text: Binding<String>, keyboardTag: Int, keyboardType: UIKeyboardType = .default, autocapitalizationType: UITextAutocapitalizationType = .none, disablingAutocorrection: Bool = true, isNumberInput: Bool = false, onCommit: @escaping () -> Void) {
        self.title = title
        self.image = image
        _editing = editing
        _text = text
        self.keyboardTag = keyboardTag
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.disablingAutocorrection = disablingAutocorrection
        self.isNumberInput = isNumberInput
        self.onCommit = onCommit
    }
    
    init(title: LocalizedStringKey, image: String, editing: Binding<Bool>, text: Binding<String>, keyboardTag: Int, keyboardType: UIKeyboardType = .default, autocapitalizationType: UITextAutocapitalizationType = .none, disablingAutocorrection: Bool = true, isNumberInput: Bool = false) {
        self.title = title
        self.image = image
        _editing = editing
        _text = text
        self.keyboardTag = keyboardTag
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.disablingAutocorrection = disablingAutocorrection
        self.isNumberInput = isNumberInput
        self.onCommit = { }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .bottom) {
                TextField("",
                          text: $text,
                          onEditingChanged: { editingChanged in
                    self.avoider.editingField = keyboardTag
                    if editingChanged {
                        withAnimation {
                            editing = true
                        }
                    } else {
                        withAnimation {
                            editing = false
                        }
                    } }, onCommit: {
                        onCommit()
                        withAnimation {
                            editing.toggle()
                        }
                    }
                )
                    .if(isNumberInput) { view in
                        view.onReceive(Just(text)) { newValue in
                            let filtered = newValue.filter { "01233456789.".contains($0) }
                            if filtered != newValue {
                                text = text
                            }
                        }
                    }
                    .keyboardType(keyboardType)
                    .autocapitalization(autocapitalizationType)
                    .disableAutocorrection(disablingAutocorrection)
                    .font(.title3)
                Spacer()
            }
            .offset(y: 4)
            .overlay(alignment: .trailing) {
                Button {
                    onCommit()
                    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Image(systemName: editing ? "checkmark.rectangle.fill" : image)
                        .resizable()
                        .scaledToFit()
                        .opacity(editing ? 1 : 0.5)
                        .foregroundColor(editing ? .accentColor : .white)
                }
                .disabled(!editing)
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
        .avoidKeyboard(tag: keyboardTag)
    }
}
