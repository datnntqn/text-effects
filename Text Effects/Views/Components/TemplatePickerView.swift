//
//  TemplatePickerView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct TemplatePickerView: View {
    @Bindable var templateManager: TemplateManager
    let onSelect: (TextTemplate) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: TemplateCategory?
    @State private var searchText = ""
    
    var filteredTemplates: [TextTemplate] {
        var templates = templateManager.allTemplates()
        
        if let category = selectedCategory {
            templates = templates.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            templates = templates.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return templates
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Bar
                    searchBar
                    
                    // Category Filter
                    categoryFilter
                    
                    // Favorites
                    if !templateManager.favoriteTemplates().isEmpty && selectedCategory == nil {
                        favoritesSection
                    }
                    
                    // Templates Grid
                    templatesGrid
                }
                .padding()
            }
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search templates", text: $searchText)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Category Filter
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    category: nil,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(TemplateCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    // MARK: - Favorites Section
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("Favorites")
                    .font(.headline)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(templateManager.favoriteTemplates()) { template in
                        TemplateGridCard(
                            template: template,
                            onSelect: {
                                onSelect(template)
                                dismiss()
                            },
                            onFavorite: {
                                templateManager.toggleFavorite(template)
                            },
                            onDelete: nil
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Templates Grid
    
    private var templatesGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(filteredTemplates) { template in
                TemplateGridCard(
                    template: template,
                    onSelect: {
                        onSelect(template)
                        dismiss()
                    },
                    onFavorite: {
                        templateManager.toggleFavorite(template)
                    },
                    onDelete: template.category == .custom ? {
                        templateManager.deleteTemplate(template)
                    } : nil
                )
            }
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let category: TemplateCategory?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let category = category {
                    Image(systemName: category.icon)
                        .font(.caption)
                    Text(category.rawValue)
                        .font(.subheadline)
                } else {
                    Text("All")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Template Grid Card

struct TemplateGridCard: View {
    let template: TextTemplate
    let onSelect: () -> Void
    let onFavorite: () -> Void
    let onDelete: (() -> Void)?
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 0) {
                // Preview
                ZStack {
                    template.backgroundColor.color
                    
                    Text(template.text)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(template.textColor.color)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .padding(8)
                }
                .frame(height: 120)
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: template.category.icon)
                            .font(.caption2)
                        Text(template.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                    
                    Text(template.category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .overlay(alignment: .topTrailing) {
                HStack(spacing: 4) {
                    // Favorite Button
                    Button {
                        onFavorite()
                    } label: {
                        Image(systemName: template.isFavorite ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(template.isFavorite ? .yellow : .white)
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    // Delete Button (for custom templates)
                    if onDelete != nil {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(6)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(8)
            }
        }
        .buttonStyle(.plain)
        .alert("Delete Template", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete?()
            }
        } message: {
            Text("Are you sure you want to delete this template?")
        }
    }
}

#Preview {
    TemplatePickerView(
        templateManager: TemplateManager(),
        onSelect: { _ in }
    )
}
