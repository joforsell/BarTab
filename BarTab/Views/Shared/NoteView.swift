//
//  NoteView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-23.
//

import SwiftUI
import SwiftUIX

struct NoteView: View {
    @Binding var note: String?
    @State private var expanded = false
    @State private var viewSize: CGSize = .zero
    @State private var textSize: CGSize = .zero
    
    var body: some View {
        Text(note ?? "")
            .readSize { size in
                viewSize = size
            }
            .fixedSize(horizontal: false, vertical: expanded ? true : false)
            .padding()
            .padding(.trailing, 16)
            .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .leading)
            .background(VisualEffectBlurView(blurStyle: .dark))
            .addBorder(Color.white.opacity(0.5), width: 1, cornerRadius: 6)
            .onTapGesture {
                withAnimation {
                    note = nil
                }
            }
            .background {
                Text(note ?? "")
                    .fixedSize()
                    .hidden()
                    .readSize { size in
                        textSize = size
                    }
            }
            .overlay(alignment: expanded ? .topTrailing : .trailing) {
                if textSize.width > viewSize.width {
                    Button {
                        withAnimation {
                            expanded.toggle()
                        }
                    } label: {
                        Image(systemName: expanded ? "rectangle.compress.vertical" : "rectangle.expand.vertical")
                            .padding(8)
                    }
                }
            }
    }
}
