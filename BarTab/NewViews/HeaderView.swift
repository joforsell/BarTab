//
//  HeaderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("beer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .frame(height: 180)
                .padding(.leading)
            VStack(alignment: .leading) {
                Text("BarTab")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 80, weight: .bold))
                Text("RT95 Ronneby")
                    .foregroundColor(.gray)
                    .font(.largeTitle)
                    .offset(y: -10)
            }
            Spacer()
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                    .padding()
                Spacer()
            }
        }
        .background(.black.opacity(0.6))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.sizeThatFits)
    }
}
