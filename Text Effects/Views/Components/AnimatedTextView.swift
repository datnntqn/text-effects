//
//  AnimatedTextView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct AnimatedTextView: View {
    let text: String
    let effect: TextEffectType
    let color: Color
    
    @State private var animationTrigger = false
    @State private var visibleCharacters = 0
    
    var body: some View {
        switch effect {
        case .none:
            Text(text)
                .foregroundStyle(color)
        case .bounce:
            BounceTextView(text: text, color: color)
        case .wave:
            WaveTextView(text: text, color: color)
        case .glow:
            GlowTextView(text: text, color: color)
        case .typewriter:
            TypewriterTextView(text: text, color: color)
        case .rainbow:
            RainbowTextView(text: text)
        }
    }
}

struct BounceTextView: View {
    let text: String
    let color: Color
    @State private var animationTime: TimeInterval = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            HStack(spacing: 0) {
                ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                    let offset = sin(timeline.date.timeIntervalSinceReferenceDate * 2 + Double(index) * 0.3) * 10
                    Text(String(character))
                        .foregroundStyle(color)
                        .offset(y: offset)
                }
            }
        }
    }
}

struct WaveTextView: View {
    let text: String
    let color: Color
    
    var body: some View {
        TimelineView(.animation) { timeline in
            HStack(spacing: 0) {
                ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                    let offset = sin(timeline.date.timeIntervalSinceReferenceDate * 2 + Double(index) * 0.5) * 8
                    Text(String(character))
                        .foregroundStyle(color)
                        .offset(y: offset)
                }
            }
        }
    }
}

struct GlowTextView: View {
    let text: String
    let color: Color
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let glowRadius = 5 + sin(timeline.date.timeIntervalSinceReferenceDate * 3) * 8
            Text(text)
                .foregroundStyle(color)
                .shadow(color: color, radius: glowRadius)
        }
    }
}

struct TypewriterTextView: View {
    let text: String
    let color: Color
    @State private var visibleCharacters = 0
    
    var body: some View {
        Text(String(text.prefix(visibleCharacters)))
            .foregroundStyle(color)
            .onAppear {
                typeWriter()
            }
    }
    
    private func typeWriter() {
        visibleCharacters = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if visibleCharacters < text.count {
                visibleCharacters += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    typeWriter()
                }
            }
        }
    }
}

struct RainbowTextView: View {
    let text: String
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let rotation = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3) / 3 * 360
            Text(text)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .hueRotation(Angle(degrees: rotation))
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        AnimatedTextView(text: "Bounce!", effect: .bounce, color: .blue)
        AnimatedTextView(text: "Wave!", effect: .wave, color: .purple)
        AnimatedTextView(text: "Glow!", effect: .glow, color: .pink)
        AnimatedTextView(text: "Typewriter!", effect: .typewriter, color: .green)
        AnimatedTextView(text: "Rainbow!", effect: .rainbow, color: .orange)
    }
    .padding()
}
