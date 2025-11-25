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

enum TextEffectType: String, CaseIterable, Identifiable {
    case none = "None"
    case bounce = "Bounce"
    case wave = "Wave"
    case glow = "Glow"
    case typewriter = "Typewriter"
    case rainbow = "Rainbow"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .none: return "text.alignleft"
        case .bounce: return "arrow.up.and.down.circle"
        case .wave: return "waveform"
        case .glow: return "sparkles"
        case .typewriter: return "keyboard"
        case .rainbow: return "paintpalette"
        }
    }
    
    var displayName: String {
        rawValue
    }
}
