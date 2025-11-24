//
//  TextStyle.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct TextStyle: Identifiable, Hashable {
    let id: UUID
    var fontName: String
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var letterSpacing: CGFloat
    var lineHeight: CGFloat
    var shadowRadius: CGFloat
    var shadowColor: CodableColor
    var outlineWidth: CGFloat
    var outlineColor: CodableColor
    var alignment: TextAlignment
    var padding: EdgeInsets
    
    init(
        id: UUID = UUID(),
        fontName: String = "System",
        fontSize: CGFloat = 28,
        fontWeight: Font.Weight = .semibold,
        letterSpacing: CGFloat = 0,
        lineHeight: CGFloat = 1.2,
        shadowRadius: CGFloat = 0,
        shadowColor: CodableColor = CodableColor(color: .clear),
        outlineWidth: CGFloat = 0,
        outlineColor: CodableColor = CodableColor(color: .clear),
        alignment: TextAlignment = .center,
        padding: EdgeInsets = EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    ) {
        self.id = id
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.letterSpacing = letterSpacing
        self.lineHeight = lineHeight
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.outlineWidth = outlineWidth
        self.outlineColor = outlineColor
        self.alignment = alignment
        self.padding = padding
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TextStyle, rhs: TextStyle) -> Bool {
        lhs.id == rhs.id
    }
}

// Codable wrapper for Color
struct CodableColor: Codable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    init(color: Color) {
        let components = color.components
        self.red = components.red
        self.green = components.green
        self.blue = components.blue
        self.opacity = components.opacity
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// Codable wrapper for Font.Weight
extension Font.Weight: Codable {
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(Double.self, forKey: .value)
        
        switch value {
        case -0.8: self = .ultraLight
        case -0.6: self = .thin
        case -0.4: self = .light
        case 0.0: self = .regular
        case 0.23: self = .medium
        case 0.4: self = .semibold
        case 0.56: self = .bold
        case 0.62: self = .heavy
        case 1.0: self = .black
        default: self = .regular
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let value: Double
        switch self {
        case .ultraLight: value = -0.8
        case .thin: value = -0.6
        case .light: value = -0.4
        case .regular: value = 0.0
        case .medium: value = 0.23
        case .semibold: value = 0.4
        case .bold: value = 0.56
        case .heavy: value = 0.62
        case .black: value = 1.0
        default: value = 0.0
        }
        try container.encode(value, forKey: .value)
    }
}

extension EdgeInsets: Codable {
    enum CodingKeys: String, CodingKey {
        case top, leading, bottom, trailing
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let top = try container.decode(CGFloat.self, forKey: .top)
        let leading = try container.decode(CGFloat.self, forKey: .leading)
        let bottom = try container.decode(CGFloat.self, forKey: .bottom)
        let trailing = try container.decode(CGFloat.self, forKey: .trailing)
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(top, forKey: .top)
        try container.encode(leading, forKey: .leading)
        try container.encode(bottom, forKey: .bottom)
        try container.encode(trailing, forKey: .trailing)
    }
}
