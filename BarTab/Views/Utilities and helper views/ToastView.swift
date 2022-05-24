//
//  ToastView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct ToastView: View {
    var systemImage: (String, Color, CGFloat)?
    var title: LocalizedStringKey
    var subTitle: LocalizedStringKey?
    
    
    var body: some View {
        HStack {
            if let systemImage = systemImage {
                let (imageName, imageColor, font) = systemImage
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
                    .font(.system(size: font))
                    .padding(.leading)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title, weight: .bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                if let subTitle = subTitle {
                    Text(subTitle)
                        .minimumScaleFactor(0.1)
                        .foregroundColor(.black)
                        .padding(.bottom, 2)
                        .padding(.trailing)
                }
            }
            .padding()
        }
        .frame(minWidth: 300, maxWidth: 500, minHeight: 60)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
        .padding()
    }
}
