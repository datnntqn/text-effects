//
//  ThemePickerView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct ThemePickerView: View {
    @Bindable var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Theme")
                .font(.headline)
                .foregroundStyle(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        ThemeButton(
                            theme: theme,
                            isSelected: themeManager.currentTheme == theme
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                themeManager.setTheme(theme)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.cardColor)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        )
    }
}

struct ThemeButton: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [theme.primaryColor, theme.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? .white : .clear, lineWidth: 3)
                    )
                    .shadow(color: theme.primaryColor.opacity(0.3), radius: 8)
                
                Text(theme.displayName)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? theme.primaryColor : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ThemePickerView(themeManager: ThemeManager())
        .padding()
}
