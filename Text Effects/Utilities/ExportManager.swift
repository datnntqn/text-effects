//
//  ExportManager.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI
import AVFoundation
import UIKit

@Observable
class ExportManager {
    var isExporting = false
    var exportProgress: Double = 0
    var lastExportedImage: UIImage?
    var lastExportedVideoURL: URL?
    
    // MARK: - Image Export
    
    @MainActor
    func exportAsImage(view: AnyView, size: CGSize = CGSize(width: 1080, height: 1920)) async -> UIImage? {
        isExporting = true
        exportProgress = 0.3
        
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = 3.0 // High quality
        
        exportProgress = 0.7
        
        guard let image = renderer.uiImage else {
            isExporting = false
            return nil
        }
        
        exportProgress = 1.0
        lastExportedImage = image
        isExporting = false
        
        return image
    }
    
    func saveImageToPhotos(_ image: UIImage) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            continuation.resume()
        }
    }
    
    // MARK: - Video Export
    
    @MainActor
    func exportAsVideo<Content: View>(
        view: Content,
        duration: Double = 3.0,
        quality: VideoQuality = .hd1080
    ) async -> URL? {
        isExporting = true
        exportProgress = 0.0
        
        let fps = 30
        let size = quality.size
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp4")
        
        guard let videoWriter = try? AVAssetWriter(url: outputURL, fileType: .mp4) else {
            isExporting = false
            return nil
        }
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ]
        
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoWriterInput,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                kCVPixelBufferWidthKey as String: Int(size.width),
                kCVPixelBufferHeightKey as String: Int(size.height)
            ]
        )
        
        videoWriter.add(videoWriterInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let totalFrames = Int(duration * Double(fps))
        let frameDuration = 1.0 / Double(fps)
        
        // Capture frames with actual time passing for animations
        for frameCount in 0..<totalFrames {
            autoreleasepool {
                while !videoWriterInput.isReadyForMoreMediaData {
                    Thread.sleep(forTimeInterval: 0.01)
                }
                
                let presentationTime = CMTime(
                    value: Int64(frameCount),
                    timescale: Int32(fps)
                )
                
                // Render current frame
                let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
                renderer.scale = 2.0
                
                if let image = renderer.uiImage,
                   let pixelBuffer = image.pixelBuffer(width: Int(size.width), height: Int(size.height)) {
                    adaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                }
                
                exportProgress = Double(frameCount + 1) / Double(totalFrames)
            }
            
            // Critical: Wait for animations to progress
            try? await Task.sleep(nanoseconds: UInt64(frameDuration * 1_000_000_000))
        }
        
        videoWriterInput.markAsFinished()
        await videoWriter.finishWriting()
        
        isExporting = false
        lastExportedVideoURL = outputURL
        
        return outputURL
    }
    
    func saveVideoToPhotos(_ videoURL: URL) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
            continuation.resume()
        }
    }
    
    // MARK: - AttributedString Export
    
    func exportAsAttributedString(
        text: String,
        color: Color,
        style: TextStyle
    ) -> AttributedString {
        var attributedString = AttributedString(text)
        
        attributedString.foregroundColor = color
        attributedString.font = .system(
            size: style.fontSize,
            weight: style.fontWeight
        )
        
        return attributedString
    }
    
    func copyAttributedStringToPasteboard(_ attributedString: AttributedString) {
        UIPasteboard.general.string = String(attributedString.characters)
    }
}

// MARK: - UIImage Extensions

extension UIImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        return buffer
    }
}
