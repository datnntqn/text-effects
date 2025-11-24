//
//  DetailView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct DetailView: View {
    let item: ContentItem
    @Bindable var themeManager: ThemeManager
    let namespace: Namespace.ID
    
    @State private var customText = "Hello, iOS 18!"
    @State private var selectedEffect: TextEffectType
    @State private var selectedColor: Color
    @State private var showColorPicker = false
    @State private var scale: CGFloat = 1.0
    
    init(item: ContentItem, themeManager: ThemeManager, namespace: Namespace.ID) {
        self.item = item
        self.themeManager = themeManager
        self.namespace = namespace
        _selectedEffect = State(initialValue: item.textEffect)
        _selectedColor = State(initialValue: item.color)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Hero Section
                VStack(spacing: 16) {
                    Image(systemName: item.icon)
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [item.color, item.color.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.bounce, value: scale)
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                                scale = 1.1
                            }
                        }
                    
                    Text(item.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(item.color)
                    
                    Text(item.subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Text Preview Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Live Preview")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    VStack(spacing: 20) {
                        AnimatedTextView(
                            text: customText,
                            effect: selectedEffect,
                            color: selectedColor
                        )
                        .font(.system(size: 28, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(themeManager.currentTheme.cardColor)
                                .shadow(color: selectedColor.opacity(0.2), radius: 15, y: 5)
                        )
                    }
                }
                .padding(.horizontal)
                
                // Text Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("Custom Text")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    TextField("Enter your text", text: $customText)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                .padding(.horizontal)
                
                // Effect Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Text Effect")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
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
                .padding(.horizontal)
                
                // Color Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Text Color")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach([Color.blue, .purple, .pink, .red, .orange, .yellow, .green, .cyan, .indigo], id: \.self) { color in
                                ColorButton(
                                    color: color,
                                    isSelected: selectedColor == color
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedColor = color
                                    }
                                }
                            }
                            
                            // Custom color picker
                            Button {
                                showColorPicker.toggle()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(
                                            AngularGradient(
                                                colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink, .red],
                                                center: .center
                                            )
                                        )
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "eyedropper")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $showColorPicker) {
                    ColorPickerSheet(selectedColor: $selectedColor)
                }
                
                // Features List
                VStack(alignment: .leading, spacing: 16) {
                    Text("Features")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    FeatureRow(
                        icon: "arrow.up.left.and.arrow.down.right",
                        title: "Zoom Transitions",
                        description: "Smooth navigation with matched geometry"
                    )
                    
                    FeatureRow(
                        icon: "textformat",
                        title: "Text Effects",
                        description: "Multiple animation styles for text"
                    )
                    
                    FeatureRow(
                        icon: "paintpalette.fill",
                        title: "Custom Colors",
                        description: "Full color customization support"
                    )
                    
                    FeatureRow(
                        icon: "sparkles",
                        title: "SF Symbols",
                        description: "Animated system icons"
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .background(themeManager.currentTheme.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EffectButton: View {
    let effect: TextEffectType
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(effect.displayName)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : color.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: isSelected ? 3 : 0)
                )
                .shadow(color: color.opacity(0.3), radius: 5)
        }
        .buttonStyle(.plain)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
}

struct ColorPickerSheet: View {
    @Binding var selectedColor: Color
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ColorPicker("Select Color", selection: $selectedColor, supportsOpacity: false)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Custom Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        DetailView(
            item: ContentItem(
                title: "Bounce Effect",
                subtitle: "Playful bouncing animation",
                color: .blue,
                icon: "arrow.up.and.down.circle.fill",
                textEffect: .bounce
            ),
            themeManager: ThemeManager(),
            namespace: Namespace().wrappedValue
        )
    }
}
