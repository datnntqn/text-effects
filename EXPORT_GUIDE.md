# Export & Sharing Guide

## 📤 Export Functionality

The Text Effects app now includes powerful export capabilities to share your creations across multiple platforms.

### Export Formats

#### 1. **Image Export (PNG/JPG)**
- **High-quality rendering** up to 4K resolution
- **Three quality presets**:
  - **Standard**: 1080 x 1920 (Instagram Story)
  - **High**: 1440 x 2560 (2K)
  - **Ultra**: 2160 x 3840 (4K)
- **3x scale rendering** for crisp text
- Perfect for social media posts

#### 2. **Video Export (MP4)**
- **Animated text effects** captured as video
- **Quality options**:
  - **HD 720p**: 720 x 1280 (TikTok)
  - **HD 1080p**: 1080 x 1920 (Instagram Reels)
  - **4K UHD**: 2160 x 3840 (YouTube)
- **Customizable duration**: 1-10 seconds
- **30 FPS** smooth playback
- Uses AVFoundation for professional quality

#### 3. **AttributedString Export**
- Copy styled text to clipboard
- Compatible with other iOS apps
- Preserves formatting and colors

---

## 🎯 How to Export

### From Advanced Editor

1. **Open Advanced Editor**
   - Tap "Advanced Editor" button on home screen
   - Or navigate from any detail view

2. **Create Your Design**
   - Enter custom text
   - Choose text effect
   - Select colors
   - Adjust styling

3. **Export Options**
   - Tap menu (⋯) in top right
   - Select "Export"
   - Choose format and quality

4. **Save or Share**
   - **Save to Photos**: Saves to your photo library
   - **Share**: Opens share sheet for social media

---

## 📱 Sharing to Social Media

### Supported Platforms

The share sheet provides direct access to:

- **Instagram** (Stories, Feed, Reels)
- **TikTok** (Videos)
- **Facebook** (Posts, Stories)
- **Twitter/X** (Posts)
- **WhatsApp** (Status, Messages)
- **Zalo** (Timeline, Messages)
- **Telegram** (Messages, Channels)
- **Email** (Attachments)
- **Messages** (iMessage)
- **More** (Any app that accepts images/videos)

### Platform-Specific Tips

#### Instagram
- **Stories**: Use Standard quality (1080x1920)
- **Feed**: Use High quality (1440x2560)
- **Reels**: Export as video, HD 1080p

#### TikTok
- Export as video
- Use HD 720p or HD 1080p
- Duration: 3-5 seconds recommended

#### Facebook
- Images: High quality
- Stories: Standard quality
- Videos: HD 1080p

#### YouTube
- Use 4K UHD for best quality
- Longer duration (5-10 seconds)
- Consider adding background music separately

---

## 🎨 Export Quality Guide

### When to Use Each Quality

| Quality | Use Case | File Size | Best For |
|---------|----------|-----------|----------|
| Standard | Quick sharing, stories | Small (~2MB) | Instagram Stories, WhatsApp |
| High | Professional posts | Medium (~5MB) | Instagram Feed, Facebook |
| Ultra | Print, wallpapers | Large (~15MB) | Desktop wallpapers, prints |

### Video Quality Guide

| Quality | Use Case | File Size | Best For |
|---------|----------|-----------|----------|
| HD 720p | Quick videos | Small (~5MB) | TikTok, quick shares |
| HD 1080p | Social media | Medium (~10MB) | Instagram Reels, Stories |
| 4K UHD | Professional | Large (~30MB) | YouTube, high-quality content |

---

## ⚙️ Technical Details

### Image Export Process

1. **Rendering**: SwiftUI view rendered using `ImageRenderer`
2. **Scaling**: 3x scale for retina quality
3. **Format**: PNG with transparency support
4. **Color Space**: sRGB for web compatibility

### Video Export Process

1. **Frame Generation**: 30 frames per second
2. **Codec**: H.264 for universal compatibility
3. **Container**: MP4 format
4. **Audio**: Silent (text-only animations)

### Performance

- **Image Export**: ~1-2 seconds
- **Video Export**: ~3-5 seconds (depends on duration)
- **Progress Indicator**: Real-time progress bar
- **Background Processing**: Non-blocking UI

---

## 🔒 Privacy & Permissions

### Required Permissions

The app requests:
- **Photo Library Access**: To save exported images/videos
- Permissions requested only when needed
- No data collection or tracking

### Data Storage

- **Exports**: Saved to your Photos app
- **Temporary Files**: Automatically cleaned up
- **Templates**: Stored locally on device
- **No Cloud Upload**: Everything stays on your device

---

## 💡 Tips & Tricks

### For Best Results

1. **Text Clarity**
   - Use high contrast colors
   - Avoid very thin fonts at small sizes
   - Test readability before exporting

2. **Animation Effects**
   - Preview effect before exporting video
   - Longer duration for complex effects
   - Consider loop-ability for social media

3. **File Size**
   - Use Standard quality for quick shares
   - Ultra quality only when needed
   - Compress videos if file size is too large

4. **Social Media**
   - Check platform requirements
   - Use recommended dimensions
   - Test on target platform

### Common Use Cases

#### Instagram Story
```
Format: Image
Quality: Standard (1080x1920)
Effect: Glow or Rainbow
Duration: N/A
```

#### TikTok Video
```
Format: Video
Quality: HD 1080p
Effect: Bounce or Wave
Duration: 3-5 seconds
```

#### Desktop Wallpaper
```
Format: Image
Quality: Ultra (4K)
Effect: Minimal (None or Glow)
Duration: N/A
```

#### Email Signature
```
Format: Image
Quality: Standard
Effect: None or subtle
Duration: N/A
```

---

## 🐛 Troubleshooting

### Export Failed

**Problem**: Export doesn't complete
- Check available storage space
- Try lower quality setting
- Restart app if needed

### Poor Quality

**Problem**: Exported image looks blurry
- Use higher quality setting
- Check original text size
- Ensure high contrast colors

### Video Not Playing

**Problem**: Exported video won't play
- Check video player compatibility
- Try different quality setting
- Ensure sufficient storage

### Can't Share to App

**Problem**: Target app not appearing in share sheet
- Ensure app is installed
- Check app permissions
- Update target app if needed

---

## 📊 Export Statistics

After exporting, you can:
- View in Photos app
- Edit with Photos editor
- Share to any app
- Use as wallpaper
- Print or save to Files

---

## 🚀 Advanced Features

### Batch Export (Coming Soon)
- Export multiple designs at once
- Consistent settings across exports
- Faster workflow

### Custom Dimensions (Coming Soon)
- Set exact pixel dimensions
- Aspect ratio presets
- Custom canvas sizes

### Export Presets (Coming Soon)
- Save favorite export settings
- Quick export with one tap
- Platform-specific presets

---

## 📞 Support

For export-related issues:
1. Check this guide first
2. Verify device storage
3. Update to latest iOS
4. Restart the app

**Note**: All exports are processed locally on your device. No internet connection required.
