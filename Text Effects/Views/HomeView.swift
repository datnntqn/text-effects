//
//  HomeView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = ContentViewModel()
    @State private var themeManager = ThemeManager()
    @Namespace private var namespace
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with animated title
                    VStack(spacing: 8) {
                        AnimatedTextView(
                            text: "Text Effects",
                            effect: .rainbow,
                            color: themeManager.currentTheme.primaryColor
                        )
                        .font(.system(size: 36, weight: .bold))
                        
                        Text("iOS 18 Features Showcase")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Theme Picker
                    ThemePickerView(themeManager: themeManager)
                        .padding(.horizontal)
                    
                    // Sticker Creator Button
                    NavigationLink {
                        StickerEditorView()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sticker Creator")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("Create animated stickers & GIFs")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "face.smiling")
                                .font(.title2)
                                .symbolEffect(.bounce, value: themeManager.currentTheme)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.orange,
                                    Color.pink
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.orange.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Advanced Editor Button
                    NavigationLink {
                        AdvancedEditorView(themeManager: themeManager)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Advanced Editor")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("Create, export & share custom designs")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "wand.and.stars")
                                .font(.title2)
                                .symbolEffect(.bounce, value: themeManager.currentTheme)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    themeManager.currentTheme.primaryColor,
                                    themeManager.currentTheme.secondaryColor
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Content Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.items) { item in
                            NavigationLink(value: item) {
                                ContentCard(item: item, namespace: namespace)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(themeManager.currentTheme.backgroundColor)
            .navigationDestination(for: ContentItem.self) { item in
                DetailView(
                    item: item,
                    themeManager: themeManager,
                    namespace: namespace
                )
                .navigationTransition(.zoom(sourceID: item.id, in: namespace))
            }
            .refreshable {
                await viewModel.refreshItems()
            }
        }
        .environment(themeManager)
    }
}

#Preview {
    HomeView()
}
