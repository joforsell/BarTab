//
//  ImagePickerHostView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-14.
//

import SwiftUI
import SwiftUIX

struct ImagePickerHostView: View {
    
    
    let customer: Customer
    @Binding var isShown: Bool
    @Binding var error: UploadError?
    @Binding var image: Image?
    @State var loading = false

    var body: some View {
        ImagePicker(customer: customer, isShown: $isShown, error: $error, image: $image, loading: $loading)
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
