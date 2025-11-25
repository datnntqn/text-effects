//
//  StickerPackManager.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

@Observable
class StickerPackManager {
    var packs: [StickerPack] = []
    
    init() {
        loadPacks()
    }
    
    func loadPacks() {
        // Load from UserDefaults or local storage
        packs = []
    }
    
    func createPack(name: String, platform: StickerPlatform) -> StickerPack {
        let pack = StickerPack(name: name, platform: platform.rawValue)
        packs.append(pack)
        savePacks()
        return pack
    }
    
    func addSticker(to pack: StickerPack, sticker: StickerItem) {
        if let index = packs.firstIndex(where: { $0.id == pack.id }) {
            packs[index].stickers.append(sticker)
            savePacks()
        }
    }
    
    func removeSticker(from pack: StickerPack, sticker: StickerItem) {
        if let packIndex = packs.firstIndex(where: { $0.id == pack.id }) {
            packs[packIndex].stickers.removeAll { $0.id == sticker.id }
            savePacks()
        }
    }
    
    func deletePack(_ pack: StickerPack) {
        packs.removeAll { $0.id == pack.id }
        savePacks()
    }
    
    private func savePacks() {
        // Save to UserDefaults or local storage
        // Simplified for now
    }
}
