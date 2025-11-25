//
//  StickerEditorView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct StickerEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var themeManager = ThemeManager()
    @State private var stickerExportManager = StickerExportManager()
    
    @State private var customText = "Hello!"
    @State private var selectedEffect: TextEffectType = .bounce
    @State private var selectedColor: Color = .white
    @State private var backgroundColor: Color = .blue
    @State private var hasTransparentBackground = true
    @State private var fontSize: CGFloat = 72
    @State private var selectedAspectRatio: StickerAspectRatio = .square
    @State private var selectedFormat: StickerFormat = .gif
    @State private var duration: Double = 2.0
    @State private var isExporting = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    previewCard
                    textInputSection
                    effectSection
                    colorSection
                    aspectRatioSection
                    formatSection
                    durationSection
                    exportButtons
                }
                .padding()
            }
            .navigationTitle("Sticker Creator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private var previewCard: some View {
        VStack {
            ZStack {
                if hasTransparentBackground {
                    CheckerboardView()
                } else {
                    backgroundColor
                }
                
                AnimatedTextView(text: customText, effect: selectedEffect, color: selectedColor)
                    .font(.system(size: fontSize, weight: .bold))
            }
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(selectedAspectRatio.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var textInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sticker Text").font(.headline)
            TextField("Enter text", text: $customText).textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var effectSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Animation Effect").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TextEffectType.allCases) { effect in
                        effectButton(effect)
                    }
                }
            }
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func effectButton(_ effect: TextEffectType) -> some View {
        Button { selectedEffect = effect } label: {
            VStack(spacing: 4) {
                Image(systemName: effect.icon).font(.title2)
                Text(effect.rawValue).font(.caption)
            }
            .frame(width: 80, height: 70)
            .background(selectedEffect == effect ? themeManager.currentTheme.primaryColor : themeManager.currentTheme.cardColor)
            .foregroundStyle(selectedEffect == effect ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors").font(.headline)
            HStack {
                VStack(alignment: .leading) {
                    Text("Text").font(.subheadline)
                    ColorPicker("", selection: $selectedColor, supportsOpacity: false).labelsHidden()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Background").font(.subheadline)
                    ColorPicker("", selection: $backgroundColor, supportsOpacity: false).labelsHidden()
                }
            }
            Toggle("Transparent Background", isOn: $hasTransparentBackground).font(.subheadline)
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var aspectRatioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Aspect Ratio").font(.headline)
            Picker("Aspect Ratio", selection: $selectedAspectRatio) {
                ForEach(StickerAspectRatio.allCases) { ratio in
                    Text(ratio.rawValue).tag(ratio)
                }
            }.pickerStyle(.segmented)
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var formatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export Format").font(.headline)
            Picker("Format", selection: $selectedFormat) {
                ForEach(StickerFormat.allCases) { format in
                    Text(format.rawValue).tag(format)
                }
            }.pickerStyle(.segmented)
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Duration").font(.headline)
                Spacer()
                Text("\(duration, specifier: "%.1f")s").foregroundStyle(.secondary)
            }
            Slider(value: $duration, in: 1...5, step: 0.5)
            
            HStack {
                Text("Font Size").font(.headline)
                Spacer()
                Text("\(Int(fontSize))pt").foregroundStyle(.secondary)
            }
            Slider(value: $fontSize, in: 24...120, step: 4)
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var exportButtons: some View {
        Button {
            Task { await exportSticker() }
        } label: {
            HStack {
                if isExporting { ProgressView().tint(.white) }
                else { Image(systemName: "square.and.arrow.down.fill") }
                Text(isExporting ? "Exporting..." : "Export Sticker")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(LinearGradient(colors: [themeManager.currentTheme.primaryColor, themeManager.currentTheme.secondaryColor], startPoint: .leading, endPoint: .trailing))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isExporting)
    }
    
    private func exportSticker() async {
        print("🚀 Export started - Format: \(selectedFormat.rawValue)")
        isExporting = true
        
        let previewView = ZStack {
            if hasTransparentBackground { Color.clear } else { backgroundColor }
            AnimatedTextView(text: customText, effect: selectedEffect, color: selectedColor)
                .font(.system(size: fontSize, weight: .bold))
        }
        
        let url: URL?
        switch selectedFormat {
        case .gif:
            print("📸 Exporting as GIF...")
            url = await stickerExportManager.exportAsGIF(view: previewView, size: selectedAspectRatio.size, duration: duration, hasTransparentBackground: hasTransparentBackground)
        case .apng:
            print("📸 Exporting as APNG...")
            url = await stickerExportManager.exportAsAPNG(view: previewView, size: selectedAspectRatio.size, duration: duration, hasTransparentBackground: hasTransparentBackground)
        case .mp4, .webp:
            print("⚠️ Format not implemented: \(selectedFormat.rawValue)")
            url = nil
        }
        
        if let url = url {
            print("💾 Attempting to save to Photos...")
            do {
                try await stickerExportManager.saveToPhotos(url)
                print("✅ Successfully saved to Photos!")
            } catch {
                print("❌ Failed to save: \(error.localizedDescription)")
            }
        } else {
            print("❌ Export failed - no URL returned")
        }
        
        isExporting = false
        print("🏁 Export complete")
    }
}

struct CheckerboardView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let size: CGFloat = 10
                let rows = Int(geometry.size.height / size) + 1
                let cols = Int(geometry.size.width / size) + 1
                for row in 0..<rows {
                    for col in 0..<cols {
                        if (row + col) % 2 == 0 {
                            path.addRect(CGRect(x: CGFloat(col) * size, y: CGFloat(row) * size, width: size, height: size))
                        }
                    }
                }
            }
            .fill(Color.gray.opacity(0.2))
        }
    }
}
