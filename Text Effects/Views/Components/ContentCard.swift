//
//  ContentCard.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct ContentCard: View {
    let item: ContentItem
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: item.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(item.color)
                    .symbolEffect(.bounce, value: item.id)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(item.color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(item.color.opacity(0.3), lineWidth: 1)
        )
        .matchedTransitionSource(id: item.id, in: namespace)
    }
}
