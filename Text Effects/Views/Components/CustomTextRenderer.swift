//
//  CustomTextRenderer.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

// Advanced text renderer for per-character styling
struct StyledText: View {
    let text: String
    let colors: [Color]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .foregroundStyle(colors[index % colors.count])
            }
        }
    }
}

// Gradient text view
struct GradientText: View {
    let text: String
    let gradient: LinearGradient
    
    var body: some View {
        Text(text)
            .foregroundStyle(gradient)
    }
}

// Multi-color attributed text
struct MultiColorText: View {
    let attributedString: AttributedString
    
    init(text: String, colorRanges: [(range: Range<String.Index>, color: Color)]) {
        var attributed = AttributedString(text)
        
        for (range, color) in colorRanges {
            if let attributedRange = Range(range, in: attributed) {
                attributed[attributedRange].foregroundColor = color
            }
        }
        
        self.attributedString = attributed
    }
    
    var body: some View {
        Text(attributedString)
    }
}

#Preview {
    VStack(spacing: 30) {
        StyledText(
            text: "Rainbow Colors",
            colors: [.red, .orange, .yellow, .green, .blue, .purple]
        )
        .font(.title)
        
        GradientText(
            text: "Gradient Text",
            gradient: LinearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .font(.title)
    }
    .padding()
}
