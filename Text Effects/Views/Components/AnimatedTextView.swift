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
    @State private var bounce = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .foregroundStyle(color)
                    .offset(y: bounce ? -10 : 0)
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.5)
                        .delay(Double(index) * 0.05)
                        .repeatForever(autoreverses: true),
                        value: bounce
                    )
            }
        }
        .onAppear {
            bounce = true
        }
    }
}

struct WaveTextView: View {
    let text: String
    let color: Color
    @State private var wave = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .foregroundStyle(color)
                    .offset(y: wave ? sin(Double(index) * 0.5) * 10 : 0)
                    .animation(
                        .easeInOut(duration: 2)
                        .delay(Double(index) * 0.05)
                        .repeatForever(autoreverses: true),
                        value: wave
                    )
            }
        }
        .onAppear {
            wave = true
        }
    }
}

struct GlowTextView: View {
    let text: String
    let color: Color
    @State private var glow = false
    
    var body: some View {
        Text(text)
            .foregroundStyle(color)
            .shadow(color: color.opacity(glow ? 0.8 : 0.3), radius: glow ? 20 : 5)
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: glow
            )
            .onAppear {
                glow = true
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
    @State private var hueRotation = 0.0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .hueRotation(Angle(degrees: hueRotation + Double(index) * 20))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                hueRotation = 360
            }
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
