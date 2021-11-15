//
//  ToastView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-14.
//

import SwiftUI

struct ToastView: View {
    var systemImage: (String, Color, CGFloat)?
    var title: String
    var subTitle: String?
    
    
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
                    .font(.title)
                if let subTitle = subTitle {
                    Text(subTitle)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                        .padding(.trailing)
                }
            }
            .padding()
        }
        .frame(minWidth: 300, minHeight: 60)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(systemImage: ("envelope.fill", Color("AppYellow"), 50), title: "Mail skickades", subTitle: "Nuvarande saldo skickades till samtliga kunder.")
            .previewLayout(.sizeThatFits)
    }
}
