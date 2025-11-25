//
//  StickerExportManager.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI
import AVFoundation
import ImageIO
import UniformTypeIdentifiers

@Observable
class StickerExportManager {
    var isExporting = false
    var exportProgress: Double = 0.0
    var lastExportedURL: URL?
    
    // MARK: - GIF Export
    
    @MainActor
    func exportAsGIF<Content: View>(
        view: Content,
        size: CGSize,
        duration: Double = 2.0,
        hasTransparentBackground: Bool = true,
        fps: Int = 20
    ) async -> URL? {
        print("🎬 Starting GIF export...")
        print("📐 Size: \(size)")
        print("⏱️ Duration: \(duration)s, FPS: \(fps)")
        
        isExporting = true
        exportProgress = 0.0
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("gif")
        
        print("📁 Output URL: \(outputURL.path)")
        
        guard let destination = CGImageDestinationCreateWithURL(
            outputURL as CFURL,
            UTType.gif.identifier as CFString,
            Int(duration * Double(fps)),
            nil
        ) else {
            print("❌ Failed to create GIF destination")
            isExporting = false
            return nil
        }
        
        print("✅ GIF destination created")
        
        let gifProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0,
                kCGImagePropertyGIFHasGlobalColorMap as String: true
            ]
        ]
        CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)
        
        let totalFrames = Int(duration * Double(fps))
        let frameDuration = 1.0 / Double(fps)
        
        for frameCount in 0..<totalFrames {
            // Wait first to allow animation to update
            try? await Task.sleep(nanoseconds: UInt64(frameDuration * 1_000_000_000))
            
            autoreleasepool {
                // Create fresh renderer for each frame
                let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
                renderer.scale = 2.0
                
                if let image = renderer.uiImage {
                    let frameProperties: [String: Any] = [
                        kCGImagePropertyGIFDictionary as String: [
                            kCGImagePropertyGIFDelayTime as String: frameDuration
                        ]
                    ]
                    
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
                    }
                }
                
                exportProgress = Double(frameCount + 1) / Double(totalFrames)
            }
        }
        
        let finalized = CGImageDestinationFinalize(destination)
        print("🎯 GIF finalized: \(finalized)")
        
        if finalized {
            let fileExists = FileManager.default.fileExists(atPath: outputURL.path)
            print("📄 File exists: \(fileExists)")
            
            if fileExists {
                let fileSize = try? FileManager.default.attributesOfItem(atPath: outputURL.path)[.size] as? Int
                print("📦 File size: \(fileSize ?? 0) bytes")
            }
        }
        
        isExporting = false
        lastExportedURL = outputURL
        
        print("✅ GIF export complete: \(outputURL.path)")
        return outputURL
    }
    
    // MARK: - APNG Export
    
    @MainActor
    func exportAsAPNG<Content: View>(
        view: Content,
        size: CGSize,
        duration: Double = 2.0,
        hasTransparentBackground: Bool = true,
        fps: Int = 20
    ) async -> URL? {
        isExporting = true
        exportProgress = 0.0
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("png")
        
        guard let destination = CGImageDestinationCreateWithURL(
            outputURL as CFURL,
            UTType.png.identifier as CFString,
            Int(duration * Double(fps)),
            nil
        ) else {
            isExporting = false
            return nil
        }
        
        let apngProperties: [String: Any] = [
            kCGImagePropertyPNGDictionary as String: [
                kCGImagePropertyAPNGLoopCount as String: 0
            ]
        ]
        CGImageDestinationSetProperties(destination, apngProperties as CFDictionary)
        
        let totalFrames = Int(duration * Double(fps))
        let frameDuration = 1.0 / Double(fps)
        
        for frameCount in 0..<totalFrames {
            // Wait first to allow animation to update
            try? await Task.sleep(nanoseconds: UInt64(frameDuration * 1_000_000_000))
            
            autoreleasepool {
                // Create fresh renderer for each frame
                let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
                renderer.scale = 2.0
                
                if let image = renderer.uiImage {
                    let frameProperties: [String: Any] = [
                        kCGImagePropertyPNGDictionary as String: [
                            kCGImagePropertyAPNGDelayTime as String: frameDuration
                        ]
                    ]
                    
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
                    }
                }
                
                exportProgress = Double(frameCount + 1) / Double(totalFrames)
            }
        }
        
        CGImageDestinationFinalize(destination)
        
        isExporting = false
        lastExportedURL = outputURL
        
        return outputURL
    }
    
    // MARK: - Sticker Pack Export
    
    func exportStickerPack(
        pack: StickerPack,
        platform: StickerPlatform
    ) async -> URL? {
        isExporting = true
        exportProgress = 0.0
        
        let packURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(pack.name)
        
        try? FileManager.default.createDirectory(at: packURL, withIntermediateDirectories: true)
        
        for (index, sticker) in pack.stickers.enumerated() {
            // Export each sticker based on format
            // This would be implemented with actual sticker rendering
            exportProgress = Double(index + 1) / Double(pack.stickers.count)
        }
        
        isExporting = false
        return packURL
    }
    
    // MARK: - Platform-Specific Export
    
    @MainActor
    func exportForPlatform<Content: View>(
        view: Content,
        platform: StickerPlatform,
        hasTransparentBackground: Bool = true
    ) async -> URL? {
        let requirements = platform.requirements
        let size = requirements.maxSize
        
        // Use first supported format
        guard let format = requirements.supportedFormats.first else {
            return nil
        }
        
        switch format {
        case .gif:
            return await exportAsGIF(
                view: view,
                size: size,
                duration: 2.0,
                hasTransparentBackground: hasTransparentBackground
            )
        case .apng:
            return await exportAsAPNG(
                view: view,
                size: size,
                duration: 2.0,
                hasTransparentBackground: hasTransparentBackground
            )
        case .mp4:
            // Use existing video export
            return nil
        case .webp:
            // WebP export would require additional library
            return nil
        }
    }
    
    // MARK: - Helper Methods
    
    func saveToPhotos(_ url: URL) async throws {
        print("💾 Saving to Photos: \(url.path)")
        
        // Check if file exists
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("❌ File does not exist at path")
            throw NSError(domain: "StickerExport", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        
        // For GIF/APNG, use PHPhotoLibrary
        if url.pathExtension.lowercased() == "gif" || url.pathExtension.lowercased() == "png" {
            print("📸 Saving image to Photos...")
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                if let image = UIImage(contentsOfFile: url.path) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    print("✅ Image saved successfully")
                    continuation.resume()
                } else {
                    print("❌ Failed to load image from file")
                    continuation.resume(throwing: NSError(domain: "StickerExport", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"]))
                }
            }
        } else {
            // For video files
            print("🎥 Saving video to Photos...")
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
                print("✅ Video saved successfully")
                continuation.resume()
            }
        }
    }
}
