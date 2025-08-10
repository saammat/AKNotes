//
//  CustomTag.swift
//  AkNotes
//
//  Created by 徐 on 2025/8/10.
//
import SwiftUI

struct CustomTag: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let color: String
    
    init(id: UUID = UUID(), name: String, icon: String, color: String = "#8B5FBF") {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
    
    var displayName: String {
        return name
    }
    
    var tagColor: Color {
        return Color(hex: color) ?? iOSDesignSystem.Colors.primary200
    }
}
