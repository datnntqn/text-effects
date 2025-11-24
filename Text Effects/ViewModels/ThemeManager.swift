//
//  ThemeManager.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

@Observable
class ThemeManager {
    var currentTheme: AppTheme = .vibrant
    var customTextColor: Color = .blue
    var selectedTextEffect: TextEffectType = .bounce
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
    
    func setTextEffect(_ effect: TextEffectType) {
        selectedTextEffect = effect
    }
}
