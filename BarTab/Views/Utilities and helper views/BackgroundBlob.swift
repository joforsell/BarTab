//
//  BackgroundBlob.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-23.
//

import SwiftUI

// MARK: - Background shape for darkening part of background
struct BackgroundBlob: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: -0.00096*width, y: 0))
        path.addLine(to: CGPoint(x: -0.00096*width, y: 0.99819*height))
        path.addLine(to: CGPoint(x: 1.00266*width, y: 1.00096*height))
        path.addCurve(to: CGPoint(x: 0.72457*width, y: 0.60832*height), control1: CGPoint(x: 1.00266*width, y: 1.00096*height), control2: CGPoint(x: 0.95695*width, y: 0.70292*height))
        path.addCurve(to: CGPoint(x: 0.58216*width, y: 0.37605*height), control1: CGPoint(x: 0.66684*width, y: 0.58481*height), control2: CGPoint(x: 0.58531*width, y: 0.46194*height))
        path.addCurve(to: CGPoint(x: 0.3339*width, y: 0.00138*height), control1: CGPoint(x: 0.576*width, y: 0.20834*height), control2: CGPoint(x: 0.48146*width, y: 0.00138*height))
        path.addCurve(to: CGPoint(x: -0.00096*width, y: 0), control1: CGPoint(x: 0.1991*width, y: 0.00138*height), control2: CGPoint(x: -0.00096*width, y: 0))
        path.closeSubpath()
        return path
    }
}
