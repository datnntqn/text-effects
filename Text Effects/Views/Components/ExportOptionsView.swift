//
//  ExportOptionsView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI
import PhotosUI

struct ExportOptionsView: View {
    @Bindable var exportManager: ExportManager
    let previewView: AnyView
    let onShare: (ShareItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFormat: ExportFormat = .image
    @State private var imageQuality: ImageQuality = .high
    @State private var videoQuality: VideoQuality = .hd1080
    @State private var videoDuration: Double = 3.0
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Preview
                    previewSection
                    
                    // Format Selection
                    formatSection
                    
                    // Quality Settings
                    if selectedFormat == .image {
                        imageQualitySection
                    } else if selectedFormat == .video {
                        videoQualitySection
                    }
                    
                    // Export Actions
                    exportActionsSection
                    
                    // Progress
                    if exportManager.isExporting {
                        progressSection
                    }
                }
                .padding()
            }
            .navigationTitle("Export Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Export completed successfully!")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Preview Section
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview")
                .font(.headline)
            
            previewView
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    // MARK: - Format Section
    
    private var formatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export Format")
                .font(.headline)
            
            Picker("Format", selection: $selectedFormat) {
                ForEach(ExportFormat.allCases, id: \.self) { format in
                    Label(format.rawValue, systemImage: format.icon)
                        .tag(format)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - Image Quality Section
    
    private var imageQualitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Image Quality")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(ImageQuality.allCases, id: \.self) { quality in
                    QualityOption(
                        title: quality.rawValue,
                        subtitle: quality.description,
                        isSelected: imageQuality == quality
                    ) {
                        imageQuality = quality
                    }
                }
            }
        }
    }
    
    // MARK: - Video Quality Section
    
    private var videoQualitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Video Settings")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(VideoQuality.allCases, id: \.self) { quality in
                    QualityOption(
                        title: quality.rawValue,
                        subtitle: quality.description,
                        isSelected: videoQuality == quality
                    ) {
                        videoQuality = quality
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Duration")
                        .font(.subheadline)
                    Spacer()
                    Text("\(String(format: "%.1f", videoDuration))s")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Slider(value: $videoDuration, in: 1...10, step: 0.5)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Export Actions Section
    
    private var exportActionsSection: some View {
        VStack(spacing: 12) {
            // Save to Photos
            Button {
                Task {
                    await saveToPhotos()
                }
            } label: {
                Label("Save to Photos", systemImage: "photo.on.rectangle.angled")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(exportManager.isExporting)
            
            // Share
            Button {
                Task {
                    await shareContent()
                }
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(exportManager.isExporting)
            
            // Copy (for AttributedString)
            if selectedFormat == .attributedString {
                Button {
                    copyAttributedString()
                } label: {
                    Label("Copy to Clipboard", systemImage: "doc.on.doc")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            ProgressView(value: exportManager.exportProgress)
                .progressViewStyle(.linear)
            
            Text("Exporting... \(Int(exportManager.exportProgress * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Export Methods
    
    private func saveToPhotos() async {
        do {
            switch selectedFormat {
            case .image:
                if let image = await exportManager.exportAsImage(
                    view: previewView,
                    size: imageQuality.size
                ) {
                    try await exportManager.saveImageToPhotos(image)
                    showSuccessAlert = true
                }
            case .video:
                if let videoURL = await exportManager.exportAsVideo(
                    view: previewView,
                    duration: videoDuration,
                    size: videoQuality.size,
                    fps: 30
                ) {
                    try await exportManager.saveVideoToPhotos(videoURL)
                    showSuccessAlert = true
                }
            case .attributedString:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    private func shareContent() async {
        switch selectedFormat {
        case .image:
            if let image = await exportManager.exportAsImage(
                view: previewView,
                size: imageQuality.size
            ) {
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("text_effect_\(UUID().uuidString).png")
                
                if let data = image.pngData() {
                    try? data.write(to: tempURL)
                    onShare(ShareItem(url: tempURL))
                    dismiss()
                }
            }
        case .video:
            if let videoURL = await exportManager.exportAsVideo(
                view: previewView,
                duration: videoDuration,
                size: videoQuality.size,
                fps: 30
            ) {
                onShare(ShareItem(url: videoURL))
                dismiss()
            }
        case .attributedString:
            break
        }
    }
    
    private func copyAttributedString() {
        // Implementation for copying attributed string
        showSuccessAlert = true
    }
}

// MARK: - Supporting Types

enum ExportFormat: String, CaseIterable {
    case image = "Image"
    case video = "Video"
    case attributedString = "Text"
    
    var icon: String {
        switch self {
        case .image: return "photo"
        case .video: return "video"
        case .attributedString: return "doc.text"
        }
    }
}

enum ImageQuality: String, CaseIterable {
    case standard = "Standard"
    case high = "High"
    case ultra = "Ultra"
    
    var size: CGSize {
        switch self {
        case .standard: return CGSize(width: 1080, height: 1920)
        case .high: return CGSize(width: 1440, height: 2560)
        case .ultra: return CGSize(width: 2160, height: 3840)
        }
    }
    
    var description: String {
        switch self {
        case .standard: return "1080 x 1920 (Instagram Story)"
        case .high: return "1440 x 2560 (2K)"
        case .ultra: return "2160 x 3840 (4K)"
        }
    }
}

enum VideoQuality: String, CaseIterable {
    case hd720 = "HD 720p"
    case hd1080 = "HD 1080p"
    case uhd4k = "4K UHD"
    
    var size: CGSize {
        switch self {
        case .hd720: return CGSize(width: 720, height: 1280)
        case .hd1080: return CGSize(width: 1080, height: 1920)
        case .uhd4k: return CGSize(width: 2160, height: 3840)
        }
    }
    
    var description: String {
        switch self {
        case .hd720: return "720 x 1280 (TikTok)"
        case .hd1080: return "1080 x 1920 (Instagram)"
        case .uhd4k: return "2160 x 3840 (YouTube)"
        }
    }
}

struct QualityOption: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ExportOptionsView(
        exportManager: ExportManager(),
        previewView: AnyView(
            Text("Preview")
                .font(.largeTitle)
                .padding()
        ),
        onShare: { _ in }
    )
}
