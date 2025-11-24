//
//  AdvancedEditorView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct AdvancedEditorView: View {
    @Bindable var themeManager: ThemeManager
    @State private var templateManager = TemplateManager()
    @State private var exportManager = ExportManager()
    
    @State private var customText = "Create Amazing Text"
    @State private var selectedEffect: TextEffectType = .glow
    @State private var selectedColor: Color = .blue
    @State private var backgroundColor: Color = .white
    @State private var textStyle = TextStyle()
    
    @State private var showTemplates = false
    @State private var showStyleEditor = false
    @State private var showExportOptions = false
    @State private var showShareSheet = false
    @State private var shareItem: ShareItem?
    
    @State private var selectedFontWeight: Font.Weight = .semibold
    @State private var showSaveTemplate = false
    @State private var templateName = ""
    @State private var selectedCategory: TemplateCategory = .custom
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Live Preview Card
                    previewCard
                    
                    // Text Input
                    textInputSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Effect & Color Selectors
                    effectSection
                    colorSection
                    
                    // Advanced Styling
                    advancedStylingSection
                    
                    // Templates
                    templatesSection
                }
                .padding()
            }
            .background(themeManager.currentTheme.backgroundColor)
            .navigationTitle("Advanced Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showExportOptions = true
                        } label: {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            showSaveTemplate = true
                        } label: {
                            Label("Save as Template", systemImage: "bookmark.fill")
                        }
                        
                        Button {
                            showTemplates = true
                        } label: {
                            Label("Browse Templates", systemImage: "square.grid.2x2")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showTemplates) {
                TemplatePickerView(
                    templateManager: templateManager,
                    onSelect: applyTemplate
                )
            }
            .sheet(isPresented: $showExportOptions) {
                ExportOptionsView(
                    exportManager: exportManager,
                    previewView: previewView,
                    onShare: { item in
                        shareItem = item
                        showShareSheet = true
                    }
                )
            }
            .sheet(isPresented: $showSaveTemplate) {
                SaveTemplateView(
                    templateName: $templateName,
                    selectedCategory: $selectedCategory,
                    onSave: saveCurrentAsTemplate
                )
            }
            .sheet(item: $shareItem) { item in
                ShareSheet(items: [item.url])
            }
        }
    }
    
    // MARK: - Preview Card
    
    private var previewCard: some View {
        VStack(spacing: 0) {
            ZStack {
                backgroundColor
                
                AnimatedTextView(
                    text: customText,
                    effect: selectedEffect,
                    color: selectedColor
                )
                .font(.system(size: textStyle.fontSize, weight: selectedFontWeight))
                .kerning(textStyle.letterSpacing)
                .lineSpacing(textStyle.lineHeight)
                .shadow(
                    color: textStyle.shadowColor.color,
                    radius: textStyle.shadowRadius
                )
                .multilineTextAlignment(textStyle.alignment)
                .padding(textStyle.padding)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(selectedColor.opacity(0.3), lineWidth: 2)
            )
        }
    }
    
    private var previewView: AnyView {
        AnyView(
            ZStack {
                backgroundColor
                
                AnimatedTextView(
                    text: customText,
                    effect: selectedEffect,
                    color: selectedColor
                )
                .font(.system(size: textStyle.fontSize, weight: selectedFontWeight))
                .kerning(textStyle.letterSpacing)
                .lineSpacing(textStyle.lineHeight)
                .shadow(
                    color: textStyle.shadowColor.color,
                    radius: textStyle.shadowRadius
                )
                .multilineTextAlignment(textStyle.alignment)
                .padding(textStyle.padding)
            }
        )
    }
    
    // MARK: - Text Input Section
    
    private var textInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Text")
                .font(.headline)
            
            TextEditor(text: $customText)
                .frame(height: 100)
                .padding(8)
                .background(themeManager.currentTheme.cardColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        HStack(spacing: 12) {
            Button {
                showExportOptions = true
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button {
                showSaveTemplate = true
            } label: {
                Label("Save", systemImage: "bookmark")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.currentTheme.primaryColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Effect Section
    
    private var effectSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text Effect")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TextEffectType.allCases, id: \.self) { effect in
                        EffectButton(
                            effect: effect,
                            isSelected: selectedEffect == effect,
                            color: selectedColor
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedEffect = effect
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Color Section
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Colors")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Text Color
                HStack {
                    Text("Text")
                        .font(.subheadline)
                        .frame(width: 80, alignment: .leading)
                    
                    ColorPicker("", selection: $selectedColor, supportsOpacity: false)
                        .labelsHidden()
                    
                    Spacer()
                }
                
                // Background Color
                HStack {
                    Text("Background")
                        .font(.subheadline)
                        .frame(width: 80, alignment: .leading)
                    
                    ColorPicker("", selection: $backgroundColor, supportsOpacity: false)
                        .labelsHidden()
                    
                    Spacer()
                }
            }
            .padding()
            .background(themeManager.currentTheme.cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Advanced Styling Section
    
    private var advancedStylingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation {
                    showStyleEditor.toggle()
                }
            } label: {
                HStack {
                    Text("Advanced Styling")
                        .font(.headline)
                    Spacer()
                    Image(systemName: showStyleEditor ? "chevron.up" : "chevron.down")
                }
                .foregroundStyle(.primary)
            }
            
            if showStyleEditor {
                VStack(spacing: 20) {
                    // Font Size
                    StyleSlider(
                        title: "Font Size",
                        value: $textStyle.fontSize,
                        range: 12...72,
                        icon: "textformat.size"
                    )
                    
                    // Font Weight
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Font Weight", systemImage: "bold")
                            .font(.subheadline)
                        
                        Picker("Weight", selection: $selectedFontWeight) {
                            Text("Light").tag(Font.Weight.light)
                            Text("Regular").tag(Font.Weight.regular)
                            Text("Medium").tag(Font.Weight.medium)
                            Text("Semibold").tag(Font.Weight.semibold)
                            Text("Bold").tag(Font.Weight.bold)
                            Text("Heavy").tag(Font.Weight.heavy)
                            Text("Black").tag(Font.Weight.black)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Letter Spacing
                    StyleSlider(
                        title: "Letter Spacing",
                        value: $textStyle.letterSpacing,
                        range: -2...10,
                        icon: "character"
                    )
                    
                    // Line Height
                    StyleSlider(
                        title: "Line Height",
                        value: $textStyle.lineHeight,
                        range: 0.5...3.0,
                        icon: "line.3.horizontal"
                    )
                    
                    // Shadow Radius
                    StyleSlider(
                        title: "Shadow",
                        value: $textStyle.shadowRadius,
                        range: 0...30,
                        icon: "shadow"
                    )
                    
                    // Text Alignment
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Alignment", systemImage: "text.alignleft")
                            .font(.subheadline)
                        
                        Picker("Alignment", selection: $textStyle.alignment) {
                            Text("Left").tag(TextAlignment.leading)
                            Text("Center").tag(TextAlignment.center)
                            Text("Right").tag(TextAlignment.trailing)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding()
                .background(themeManager.currentTheme.cardColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Templates Section
    
    private var templatesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Quick Templates")
                    .font(.headline)
                Spacer()
                Button("See All") {
                    showTemplates = true
                }
                .font(.subheadline)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(templateManager.templates.prefix(4)) { template in
                        TemplateCard(template: template) {
                            applyTemplate(template)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func applyTemplate(_ template: TextTemplate) {
        customText = template.text
        selectedColor = template.textColor.color
        backgroundColor = template.backgroundColor.color
        selectedEffect = TextEffectType(rawValue: template.effect) ?? .none
        textStyle.fontSize = template.fontSize
        selectedFontWeight = template.fontWeight
    }
    
    private func saveCurrentAsTemplate() {
        let template = TextTemplate(
            name: templateName.isEmpty ? "Custom Template" : templateName,
            category: selectedCategory,
            text: customText,
            textColor: CodableColor(color: selectedColor),
            backgroundColor: CodableColor(color: backgroundColor),
            effect: selectedEffect.rawValue,
            fontSize: textStyle.fontSize,
            fontWeight: selectedFontWeight
        )
        templateManager.saveTemplate(template)
        showSaveTemplate = false
        templateName = ""
    }
}

// MARK: - Supporting Views

struct StyleSlider: View {
    let title: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.subheadline)
                Spacer()
                Text(String(format: "%.1f", value))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Slider(value: $value, in: range)
                .tint(.blue)
        }
    }
}

struct TemplateCard: View {
    let template: TextTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: template.category.icon)
                    .font(.title2)
                    .foregroundStyle(template.textColor.color)
                
                Text(template.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(template.category.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 120, height: 120)
            .padding()
            .background(template.backgroundColor.color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(template.textColor.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}

#Preview {
    AdvancedEditorView(themeManager: ThemeManager())
}
