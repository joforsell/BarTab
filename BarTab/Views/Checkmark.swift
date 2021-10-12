//
//  Checkmark.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-12.
//

import SwiftUI

struct Checkmark: View {
    var height: CGFloat
    var width: CGFloat
    private var circleHeight: CGFloat {
        height*1.5
    }
    private var circleWidth: CGFloat {
        width*1.5
    }
    
    @State private var percentage: CGFloat = .zero
    @State private var scaleFactor: CGFloat = 0.4
    
    var body: some View {
        GeometryReader { geometry in
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
                .animation(.easeOut(duration: 1.5).delay(0.1))
                .onAppear {
                    percentage = 1.0
                }
                .padding()
            }
        }
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        Checkmark(height: 60, width: 60)
    }
}
