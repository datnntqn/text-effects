//
//  Extensions.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

// Color extensions for better theme support
extension Color {
    static func random() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        
        return (Double(r), Double(g), Double(b), Double(o))
    }
}

// View extensions for common modifiers
extension View {
    func cardStyle(backgroundColor: Color = .white, shadowColor: Color = .black.opacity(0.1)) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: 10, y: 5)
            )
    }
    
    func glassEffect() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// String extensions for text manipulation
extension String {
    var words: [String] {
        components(separatedBy: .whitespaces).filter { !$0.isEmpty }
    }
    
    func chunked(by size: Int) -> [String] {
        stride(from: 0, to: count, by: size).map {
            let start = index(startIndex, offsetBy: $0)
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            return String(self[start..<end])
        }
    }
}
