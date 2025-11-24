//
//  TextTemplate.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct TextTemplate: Identifiable, Hashable {
    let id: UUID
    var name: String
    var category: TemplateCategory
    var text: String
    var textColor: CodableColor
    var backgroundColor: CodableColor
    var effect: String // TextEffectType rawValue
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var isFavorite: Bool
    var createdDate: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        category: TemplateCategory,
        text: String,
        textColor: CodableColor,
        backgroundColor: CodableColor,
        effect: String,
        fontSize: CGFloat = 28,
        fontWeight: Font.Weight = .semibold,
        isFavorite: Bool = false,
        createdDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.effect = effect
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.isFavorite = isFavorite
        self.createdDate = createdDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TextTemplate, rhs: TextTemplate) -> Bool {
        lhs.id == rhs.id
    }
}

enum TemplateCategory: String, Codable, CaseIterable {
    case quote = "Quote"
    case caption = "Caption"
    case greeting = "Greeting Card"
    case wallpaper = "Wallpaper"
    case banner = "Banner"
    case invitation = "Invitation"
    case custom = "Custom"
    
    var icon: String {
        switch self {
        case .quote: return "quote.bubble.fill"
        case .caption: return "text.bubble.fill"
        case .greeting: return "envelope.fill"
        case .wallpaper: return "photo.fill"
        case .banner: return "rectangle.fill"
        case .invitation: return "calendar.badge.plus"
        case .custom: return "star.fill"
        }
    }
}

// Preset templates
extension TextTemplate {
    static let presets: [TextTemplate] = [
        TextTemplate(
            name: "Motivational Quote",
            category: .quote,
            text: "Dream Big, Work Hard",
            textColor: CodableColor(color: .white),
            backgroundColor: CodableColor(color: .blue),
            effect: TextEffectType.glow.rawValue,
            fontSize: 32,
            fontWeight: .bold
        ),
        TextTemplate(
            name: "Instagram Caption",
            category: .caption,
            text: "Living my best life ✨",
            textColor: CodableColor(color: .pink),
            backgroundColor: CodableColor(color: .white),
            effect: TextEffectType.rainbow.rawValue,
            fontSize: 24,
            fontWeight: .semibold
        ),
        TextTemplate(
            name: "Birthday Card",
            category: .greeting,
            text: "Happy Birthday! 🎉",
            textColor: CodableColor(color: .orange),
            backgroundColor: CodableColor(color: Color(red: 1.0, green: 0.95, blue: 0.8)),
            effect: TextEffectType.bounce.rawValue,
            fontSize: 36,
            fontWeight: .heavy
        ),
        TextTemplate(
            name: "Minimal Wallpaper",
            category: .wallpaper,
            text: "Stay Focused",
            textColor: CodableColor(color: .black),
            backgroundColor: CodableColor(color: Color(red: 0.95, green: 0.95, blue: 0.95)),
            effect: TextEffectType.none.rawValue,
            fontSize: 40,
            fontWeight: .light
        ),
        TextTemplate(
            name: "Event Banner",
            category: .banner,
            text: "Grand Opening",
            textColor: CodableColor(color: .white),
            backgroundColor: CodableColor(color: .red),
            effect: TextEffectType.wave.rawValue,
            fontSize: 44,
            fontWeight: .black
        ),
        TextTemplate(
            name: "Wedding Invitation",
            category: .invitation,
            text: "You're Invited",
            textColor: CodableColor(color: Color(red: 0.8, green: 0.6, blue: 0.4)),
            backgroundColor: CodableColor(color: Color(red: 1.0, green: 0.98, blue: 0.95)),
            effect: TextEffectType.glow.rawValue,
            fontSize: 30,
            fontWeight: .medium
        )
    ]
}
