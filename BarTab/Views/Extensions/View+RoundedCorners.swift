//
//  View + RoundedCorners.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-16.
//

import SwiftUI

private struct RoundedCornersRectangle: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path (in rect: CGRect) -> Path {
        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius( radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornersRectangle(radius: radius, corners: corners))
    }
}
