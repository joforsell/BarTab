//
//  ImagePickerHostView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-14.
//

import SwiftUI

struct ImagePickerHostView: View {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    var body: some View {
        ImagePicker(isShown: $isShown, image: $image)
    }
}
