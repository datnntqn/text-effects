//
//  StickerFormat.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

// MARK: - Sticker Format

enum StickerFormat: String, CaseIterable, Identifiable {
    case gif = "GIF"
    case apng = "APNG"
    case mp4 = "MP4"
    case webp = "WebP"
    
    var id: String { rawValue }
    
    var fileExtension: String {
        switch self {
        case .gif: return "gif"
        case .apng: return "png"
        case .mp4: return "mp4"
        case .webp: return "webp"
        }
    }
}

// MARK: - Aspect Ratio

enum StickerAspectRatio: String, CaseIterable, Identifiable {
    case square = "Square 1:1"
    case portrait = "Portrait 9:16"
    case landscape = "Landscape 16:9"
    case story = "Story 9:16"
    case chat = "Chat 1:1"
    
    var id: String { rawValue }
    
    var ratio: CGFloat {
        switch self {
        case .square, .chat: return 1.0
        case .portrait, .story: return 9.0 / 16.0
        case .landscape: return 16.0 / 9.0
        }
    }
    
    var size: CGSize {
        switch self {
        case .square, .chat: return CGSize(width: 512, height: 512)
        case .portrait, .story: return CGSize(width: 1080, height: 1920)
        case .landscape: return CGSize(width: 1920, height: 1080)
        }
    }
    
    var icon: String {
        switch self {
        case .square, .chat: return "square"
        case .portrait, .story: return "rectangle.portrait"
        case .landscape: return "rectangle"
        }
    }
}

// MARK: - Sticker Platform

enum StickerPlatform: String, CaseIterable, Identifiable {
    case whatsapp = "WhatsApp"
    case telegram = "Telegram"
    case instagram = "Instagram"
    case imessage = "iMessage"
    case generic = "Generic"
    
    var id: String { rawValue }
    
    var requirements: StickerRequirements {
        switch self {
        case .whatsapp:
            return StickerRequirements(
                maxSize: CGSize(width: 512, height: 512),
                maxFileSize: 100_000, // 100KB
                supportedFormats: [.webp],
                requiresTransparency: true,
                aspectRatio: .square
            )
        case .telegram:
            return StickerRequirements(
                maxSize: CGSize(width: 512, height: 512),
                maxFileSize: 500_000, // 500KB
                supportedFormats: [.webp, .gif],
                requiresTransparency: true,
                aspectRatio: .square
            )
        case .instagram:
            return StickerRequirements(
                maxSize: CGSize(width: 1080, height: 1920),
                maxFileSize: 5_000_000, // 5MB
                supportedFormats: [.gif, .mp4],
                requiresTransparency: false,
                aspectRatio: .story
            )
        case .imessage:
            return StickerRequirements(
                maxSize: CGSize(width: 618, height: 618),
                maxFileSize: 500_000,
                supportedFormats: [.apng, .gif],
                requiresTransparency: true,
                aspectRatio: .square
            )
        case .generic:
            return StickerRequirements(
                maxSize: CGSize(width: 1024, height: 1024),
                maxFileSize: 1_000_000,
                supportedFormats: [.gif, .mp4, .apng],
                requiresTransparency: false,
                aspectRatio: .square
            )
        }
    }
    
    var icon: String {
        switch self {
        case .whatsapp: return "message.fill"
        case .telegram: return "paperplane.fill"
        case .instagram: return "camera.fill"
        case .imessage: return "message.badge.filled.fill"
        case .generic: return "square.grid.2x2.fill"
        }
    }
}

// MARK: - Sticker Requirements

struct StickerRequirements {
    let maxSize: CGSize
    let maxFileSize: Int
    let supportedFormats: [StickerFormat]
    let requiresTransparency: Bool
    let aspectRatio: StickerAspectRatio
}

// MARK: - Sticker Pack

struct StickerPack: Identifiable, Codable {
    let id: UUID
    var name: String
    var stickers: [StickerItem]
    var platform: String // StickerPlatform rawValue
    var createdDate: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        stickers: [StickerItem] = [],
        platform: String,
        createdDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.stickers = stickers
        self.platform = platform
        self.createdDate = createdDate
    }
}

// MARK: - Sticker Item

struct StickerItem: Identifiable, Codable {
    let id: UUID
    var text: String
    var effect: String // TextEffectType rawValue
    var textColor: CodableColor
    var backgroundColor: CodableColor
    var fontSize: CGFloat
    var hasTransparentBackground: Bool
    var aspectRatio: String // StickerAspectRatio rawValue
    var format: String // StickerFormat rawValue
    var thumbnailData: Data?
    
    init(
        id: UUID = UUID(),
        text: String,
        effect: String,
        textColor: CodableColor,
        backgroundColor: CodableColor,
        fontSize: CGFloat = 48,
        hasTransparentBackground: Bool = true,
        aspectRatio: String = "1:1",
        format: String = "gif"
    ) {
        self.id = id
        self.text = text
        self.effect = effect
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.hasTransparentBackground = hasTransparentBackground
        self.aspectRatio = aspectRatio
        self.format = format
    }
}
