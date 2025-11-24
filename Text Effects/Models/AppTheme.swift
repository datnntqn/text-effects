//
//  AppTheme.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case vibrant = "Vibrant"
    case ocean = "Ocean"
    case sunset = "Sunset"
    
    var displayName: String {
        rawValue
    }
    
    var primaryColor: Color {
        switch self {
        case .light:
            return Color(red: 0.2, green: 0.4, blue: 0.8)
        case .dark:
            return Color(red: 0.6, green: 0.6, blue: 0.8)
        case .vibrant:
            return Color(red: 1.0, green: 0.2, blue: 0.6)
        case .ocean:
            return Color(red: 0.0, green: 0.5, blue: 0.7)
        case .sunset:
            return Color(red: 1.0, green: 0.4, blue: 0.2)
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .light:
            return Color(red: 0.8, green: 0.8, blue: 0.9)
        case .dark:
            return Color(red: 0.2, green: 0.2, blue: 0.3)
        case .vibrant:
            return Color(red: 0.8, green: 0.0, blue: 0.8)
        case .ocean:
            return Color(red: 0.0, green: 0.7, blue: 0.9)
        case .sunset:
            return Color(red: 1.0, green: 0.6, blue: 0.0)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .light:
            return Color(red: 0.98, green: 0.98, blue: 1.0)
        case .dark:
            return Color(red: 0.1, green: 0.1, blue: 0.15)
        case .vibrant:
            return Color(red: 0.05, green: 0.05, blue: 0.1)
        case .ocean:
            return Color(red: 0.9, green: 0.95, blue: 0.98)
        case .sunset:
            return Color(red: 0.98, green: 0.92, blue: 0.85)
        }
    }
    
    var cardColor: Color {
        switch self {
        case .light:
            return .white
        case .dark:
            return Color(red: 0.15, green: 0.15, blue: 0.2)
        case .vibrant:
            return Color(red: 0.1, green: 0.1, blue: 0.2)
        case .ocean:
            return Color(red: 0.95, green: 0.98, blue: 1.0)
        case .sunset:
            return Color(red: 1.0, green: 0.95, blue: 0.9)
        }
    }
}
