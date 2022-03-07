//
//  UpdateTagView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-18.
//

import SwiftUI
import SwiftUIX
import Introspect
import ToastUI

struct UpdateTagView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let customer: Customer
    
    @State private var tagKey = ""
    @State private var isShowingKeyUpdatedToast = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                ZStack {
                    TextField("Scan your tag", text: $tagKey, onCommit: {
                        customerListVM.updateKey(of: customer, with: tagKey)
                        isShowingKeyUpdatedToast = true
                    })
                        .opacity(0)
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "wave.3.right.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width * 0.3)
                            .padding(48)
                            .foregroundColor(.accentColor)
                        HStack {
                            Text("Scan a tag to assign it to")
                            Text("\(customer.name).")
                                .fontWeight(.heavy)
                        }
                        .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .toast(isPresented: $isShowingKeyUpdatedToast, dismissAfter: 3, onDismiss: {
            presentationMode.wrappedValue.dismiss()
        }) {
            ToastView(systemImage: ("checkmark.circle.fill", .accentColor, 50), title: "RFID tag was updated", subTitle: "The scanned RFID tag is now assigned to \(customer.name)")
            }
        .introspectTextField { textField in
            textField.becomeFirstResponder()
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}
