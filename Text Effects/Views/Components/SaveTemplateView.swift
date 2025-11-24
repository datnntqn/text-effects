//
//  SaveTemplateView.swift
//  Text Effects
//
//  Created by DATNNT on 24/11/25.
//

import SwiftUI

struct SaveTemplateView: View {
    @Binding var templateName: String
    @Binding var selectedCategory: TemplateCategory
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Template Name", text: $templateName)
                        .focused($isNameFieldFocused)
                } header: {
                    Text("Name")
                } footer: {
                    Text("Give your template a memorable name")
                }
                
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(TemplateCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                } header: {
                    Text("Category")
                } footer: {
                    Text("Choose a category for easy organization")
                }
                
                Section {
                    Button {
                        onSave()
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save Template")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(templateName.isEmpty)
                }
            }
            .navigationTitle("Save Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isNameFieldFocused = true
            }
        }
    }
}

#Preview {
    SaveTemplateView(
        templateName: .constant("My Template"),
        selectedCategory: .constant(.custom),
        onSave: { }
    )
}
