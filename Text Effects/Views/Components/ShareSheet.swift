//
//  ShareSheet.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        // Customize for social media sharing
        controller.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks
        ]
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}

// Custom activity for specific social media platforms
class CustomShareActivity: UIActivity {
    let title: String
    let image: UIImage?
    let action: () -> Void
    
    init(title: String, image: UIImage?, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
        super.init()
    }
    
    override var activityTitle: String? {
        return title
    }
    
    override var activityImage: UIImage? {
        return image
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func perform() {
        action()
        activityDidFinish(true)
    }
}
