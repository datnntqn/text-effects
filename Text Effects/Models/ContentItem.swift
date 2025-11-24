//
//  ContentItem.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct ContentItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
    let icon: String
    let textEffect: TextEffectType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ContentItem, rhs: ContentItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum TextEffectType: String, CaseIterable {
    case none = "None"
    case bounce = "Bounce"
    case wave = "Wave"
    case glow = "Glow"
    case typewriter = "Typewriter"
    case rainbow = "Rainbow"
    
    var displayName: String {
        rawValue
    }
}
