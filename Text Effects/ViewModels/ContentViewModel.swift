//
//  ContentViewModel.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

@Observable
class ContentViewModel {
    var items: [ContentItem] = []
    var isLoading = false
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        items = [
            ContentItem(
                title: "Bounce Effect",
                subtitle: "Playful bouncing animation",
                color: .blue,
                icon: "arrow.up.and.down.circle.fill",
                textEffect: .bounce
            ),
            ContentItem(
                title: "Wave Effect",
                subtitle: "Smooth wave motion",
                color: .purple,
                icon: "waveform.circle.fill",
                textEffect: .wave
            ),
            ContentItem(
                title: "Glow Effect",
                subtitle: "Beautiful glowing text",
                color: .pink,
                icon: "sparkles",
                textEffect: .glow
            ),
            ContentItem(
                title: "Typewriter",
                subtitle: "Classic typing animation",
                color: .green,
                icon: "keyboard.fill",
                textEffect: .typewriter
            ),
            ContentItem(
                title: "Rainbow",
                subtitle: "Colorful gradient text",
                color: .orange,
                icon: "paintpalette.fill",
                textEffect: .rainbow
            ),
            ContentItem(
                title: "Custom Colors",
                subtitle: "Create your own palette",
                color: .cyan,
                icon: "eyedropper.full",
                textEffect: .none
            ),
            ContentItem(
                title: "Dynamic Themes",
                subtitle: "Switch themes instantly",
                color: .indigo,
                icon: "paintbrush.fill",
                textEffect: .none
            ),
            ContentItem(
                title: "Zoom Transitions",
                subtitle: "Smooth navigation effects",
                color: .teal,
                icon: "arrow.up.left.and.arrow.down.right",
                textEffect: .none
            )
        ]
    }
    
    func refreshItems() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadItems()
        isLoading = false
    }
}
