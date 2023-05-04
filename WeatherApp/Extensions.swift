//
//  Extensions.swift
//  WeatherApp
//
//  Created by Guntars Reiss on 03/05/2023.
//

import Foundation
import SwiftUI

// API will return information as double, so we must round them up to zero decimals
extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

// Makes it possible to choose which corner to round
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
