//
//  OrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-26.
//

import SwiftUI
import Introspect

struct OrderView: View {
    @EnvironmentObject var userStore: UserStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tagKey = ""
    @Binding var price: Int
    
    var body: some View {
        ZStack {
            TextField("Läs av tag", text: $tagKey)
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .background(Color.black.opacity(0.4))
                .onChange(of: tagKey) { _ in
                    userStore.drinkBought(by: self.tagKey, for: self.price)
                    presentationMode.wrappedValue.dismiss()
                }
            Image(systemName: "sensor.tag.radiowaves.forward")
                .font(.system(size: 300))
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: UIScreen.main.bounds.height / 12, leading: 0, bottom: 0, trailing: UIScreen.main.bounds.width / 6))
                        .onTapGesture { presentationMode.wrappedValue.dismiss() }
                        .zIndex(2)
                }
                Spacer()
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(price: .constant(20))
    }
}
