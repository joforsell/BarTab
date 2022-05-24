//
//  ImagePickerHostView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-14.
//

import SwiftUI
import SwiftUIX

struct ImagePickerHostView: View {
    
    
    @Binding var customer: Customer
    @Binding var isShown: Bool
    @Binding var error: UploadError?
    @State var loading = false
    let isCamera: Bool

    var body: some View {
        ImagePicker(customer: $customer, isShown: $isShown, error: $error, loading: $loading, isCamera: isCamera)
            .overlay {
                if loading {
                    VStack(alignment: .center) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding()
                        Text("Saving")
                            .textCase(.uppercase)
                            .font(.caption)
                    }
                    .frame(width: 100, height: 100)
                    .background(VisualEffectBlurView(blurStyle: .dark))
                    .cornerRadius(10)
                }
            }
    }
}
