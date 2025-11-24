//
//  TemplateManager.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

@Observable
class TemplateManager {
    var templates: [TextTemplate] = []
    var customTemplates: [TextTemplate] = []
    
    init() {
        loadTemplates()
    }
    
    func loadTemplates() {
        // Load preset templates
        templates = TextTemplate.presets
        
        // Load custom templates from UserDefaults (simplified - just store in memory for now)
        customTemplates = []
    }
    
    func saveTemplate(_ template: TextTemplate) {
        customTemplates.append(template)
    }
    
    func deleteTemplate(_ template: TextTemplate) {
        customTemplates.removeAll { $0.id == template.id }
    }
    
    func toggleFavorite(_ template: TextTemplate) {
        if let index = templates.firstIndex(where: { $0.id == template.id }) {
            templates[index].isFavorite.toggle()
        } else if let index = customTemplates.firstIndex(where: { $0.id == template.id }) {
            customTemplates[index].isFavorite.toggle()
        }
    }
    
    func allTemplates() -> [TextTemplate] {
        templates + customTemplates
    }
    
    func templates(for category: TemplateCategory) -> [TextTemplate] {
        allTemplates().filter { $0.category == category }
    }
    
    func favoriteTemplates() -> [TextTemplate] {
        allTemplates().filter { $0.isFavorite }
    }
}
