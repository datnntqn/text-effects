# Text Effects - iOS 18 Showcase App

A modern iOS 18 application demonstrating advanced SwiftUI features including Zoom Transitions, Text Effects, Dynamic Theming, and Professional Export capabilities.

## Features

### 🎯 iOS 18 Features
- **Zoom Transitions**: Smooth navigation using `.matchedTransitionSource` and `.navigationTransition(.zoom)`
- **Text Effects**: Multiple animation styles (Bounce, Wave, Glow, Typewriter, Rainbow)
- **Custom Colors**: Full color customization with AttributedString support
- **Dynamic Themes**: 5 beautiful themes (Light, Dark, Vibrant, Ocean, Sunset)
- **SF Symbols**: Animated system icons with symbol effects

### 📤 Export & Sharing
- **Image Export**: High-quality PNG up to 4K resolution (Standard, High, Ultra)
- **Video Export**: Animated MP4 videos with customizable duration (720p, 1080p, 4K)
- **Share Sheet**: Direct sharing to Instagram, TikTok, Facebook, Zalo, Email, and more
- **AttributedString**: Copy styled text to clipboard

### 🎨 Advanced Editor
- **Professional Controls**: Font size, weight, spacing, shadows, alignment
- **Template System**: 6 preset templates + custom template saving
- **Live Preview**: Real-time design updates
- **Layout Controls**: Padding, alignment, and spacing adjustments
- **Multiple Effects**: Stack and combine visual effects

### 🎨 Text Effects
1. **Bounce**: Playful bouncing animation for each character
2. **Wave**: Smooth wave motion across the text
3. **Glow**: Beautiful glowing effect with pulsing shadows
4. **Typewriter**: Classic typing animation
5. **Rainbow**: Colorful gradient with hue rotation

### 🌈 Themes
- **Light**: Clean and bright interface
- **Dark**: Modern dark mode
- **Vibrant**: Bold and colorful
- **Ocean**: Calm blue tones
- **Sunset**: Warm orange hues

## Project Structure

```
Text Effects/
├── Models/
│   ├── ContentItem.swift          # Data model for content items
│   ├── AppTheme.swift              # Theme definitions
│   ├── TextStyle.swift             # Text styling properties
│   └── TextTemplate.swift          # Template data model
├── ViewModels/
│   ├── ThemeManager.swift          # Theme state management
│   ├── ContentViewModel.swift      # Content data management
│   └── TemplateManager.swift       # Template management
├── Views/
│   ├── HomeView.swift              # Main grid view
│   ├── DetailView.swift            # Detail view with zoom transition
│   ├── AdvancedEditorView.swift    # Professional editor
│   └── Components/
│       ├── AnimatedTextView.swift  # Text effect implementations
│       ├── ContentCard.swift       # Grid item card
│       ├── ThemePickerView.swift   # Theme selector
│       ├── CustomTextRenderer.swift # Advanced text rendering
│       ├── ExportOptionsView.swift # Export settings
│       ├── TemplatePickerView.swift # Template browser
│       ├── SaveTemplateView.swift  # Template saving
│       └── ShareSheet.swift        # Social sharing
├── Utilities/
│   ├── Extensions.swift            # Helper extensions
│   └── ExportManager.swift         # Export functionality
└── Resources/
    └── Assets.xcassets/            # App assets
```

## Requirements

- iOS 18.0+
- Xcode 16.0+
- Swift 6.0+

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **@Observable**: New observation framework (iOS 17+)
- **Matched Geometry Effect**: For smooth transitions
- **Navigation Stack**: Modern navigation
- **Lazy Grids**: Efficient scrolling performance
- **Swift Concurrency**: async/await for data operations

## Implementation Highlights

### Zoom Transitions
```swift
@Namespace private var namespace

// Source view
ContentCard(item: item, namespace: namespace)
    .matchedTransitionSource(id: item.id, in: namespace)

// Destination view
DetailView(item: item, namespace: namespace)
    .navigationTransition(.zoom(sourceID: item.id, in: namespace))
```

### Text Effects
Custom animations using SwiftUI's animation system with per-character effects:
```swift
ForEach(Array(text.enumerated()), id: \.offset) { index, character in
    Text(String(character))
        .offset(y: bounce ? -10 : 0)
        .animation(.spring().delay(Double(index) * 0.05), value: bounce)
}
```

### Dynamic Theming
Observable theme manager with instant theme switching:
```swift
@Observable
class ThemeManager {
    var currentTheme: AppTheme = .vibrant
    // Theme properties and methods
}
```

## Performance Optimizations

- **Lazy Loading**: LazyVGrid for efficient grid rendering
- **State Management**: @Observable for minimal re-renders
- **Async Operations**: Swift concurrency for smooth UI
- **Efficient Animations**: Optimized per-character animations

## Accessibility

- Dynamic type support
- Color contrast compliance
- VoiceOver compatibility
- Reduced motion support (can be added)

## Documentation

- **[README.md](README.md)** - This file, project overview
- **[FEATURES.md](FEATURES.md)** - Detailed feature documentation
- **[QUICKSTART.md](QUICKSTART.md)** - Getting started guide
- **[EXPORT_GUIDE.md](EXPORT_GUIDE.md)** - Export and sharing guide
- **[ADVANCED_EDITOR_GUIDE.md](ADVANCED_EDITOR_GUIDE.md)** - Advanced editor manual

## Completed Features

- [x] iOS 18 Zoom Transitions
- [x] 5 Text Effects (Bounce, Wave, Glow, Typewriter, Rainbow)
- [x] Dynamic Theming (5 themes)
- [x] Advanced Text Editor
- [x] Export as Image (PNG, up to 4K)
- [x] Export as Video (MP4, up to 4K)
- [x] Share to Social Media
- [x] Template System (6 presets)
- [x] Custom Template Saving
- [x] Professional Styling Controls

## Future Enhancements

- [ ] App Intents for Siri integration
- [ ] Home Screen widgets
- [ ] Lock Screen widgets
- [ ] Custom font support
- [ ] More text effects (10+ total)
- [ ] Animation speed controls
- [ ] Gradient backgrounds
- [ ] Multiple text layers
- [ ] GIF export
- [ ] Batch export

## Building and Running

1. Open `Text Effects.xcodeproj` in Xcode 16+
2. Select iOS 18+ simulator or device
3. Build and run (⌘R)

## License

Created by DATNNT on 24/11/25.

---

**Note**: This app requires iOS 18 for full functionality, particularly for zoom transitions and latest SwiftUI features.
