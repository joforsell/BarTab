//
//  CheckmarkView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-11.
//

import SwiftUI

struct CheckmarkView: View {
    var height: CGFloat
    var width: CGFloat
    var drink: Drink
    
    private var circleHeight: CGFloat {
        height*1.5
    }
    private var circleWidth: CGFloat {
        width*1.5
    }
    
    @State private var percentage: CGFloat = .zero
    @State private var scaleFactor: CGFloat = 0.4
    
    var body: some View {
        HStack {
            checkmark
            VStack(alignment: .leading) {
                Text("Tack för din beställning.")
                    .font(.title)
                    .fontWeight(.bold)
                Text("\(drink.price) kr har dragits från ditt saldo.")
            }
            .padding()
        }
        .frame(width: width*8, height: height, alignment: .center)
        .background(
            background
        )
    }
}



struct CheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            CheckmarkView(height: 60, width: 60, drink: Drink(name: "Öl", price: 40))
        }
    }
}






extension CheckmarkView {
    var background: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(.white)
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(.green.opacity(0.5))
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(Color.white.opacity(0.3), lineWidth: 5)
        }
    }
    
    var checkmark: some View {
        ZStack {
            Circle()
                .scale(scaleFactor)
                .opacity(scaleFactor)
                .animation(.interpolatingSpring(mass: 0.2, stiffness: 1, damping: 0.7, initialVelocity: 5))
                .onAppear {
                    scaleFactor = 1
                }
                .frame(width: width*1.5, height: height*1.5)
                .foregroundColor(.green)
            Path { path in
                path.move(to: CGPoint(x: 0, y: height*0.5))
                path.addLine(to: CGPoint(x: width/2, y: height))
                path.addLine(to: CGPoint(x: width*0.9, y: height*0.1))
            }
                .trim(from: 0, to: percentage)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .animation(.easeOut(duration: 0.5).delay(0.1))
                .onAppear {
                    percentage = 1.0
                }
                .frame(width: width, height: height)
                .padding()
        }
        .padding()
    }
}
