import Foundation
import SwiftUI

enum NoteTag: String, CaseIterable, Codable, Hashable {
    case todo = "todo"
    case idea = "idea"
    case tools = "tools"
    case general = "general"
    
    var displayName: String {
        switch self {
        case .todo: return "待办"
        case .idea: return "想法"
        case .tools: return "工具"
        case .general: return "一般"
        }
    }
    
    var color: Color {
        switch self {
        case .todo: return .orange
        case .idea: return .blue
        case .tools: return .green
        case .general: return .gray
        }
    }
}

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

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    let content: String
    let tag: NoteTag
    let customTag: CustomTag?
    let createdAt: Date
    
    init(id: UUID = UUID(), content: String, tag: NoteTag, customTag: CustomTag? = nil, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.tag = tag
        self.customTag = customTag
        self.createdAt = createdAt
    }
    
    var formattedContent: String {
        if let customTag = customTag {
            "\(customTag.name)：\(content)"
        } else {
            "\(tag.rawValue)：\(content)"
        }
    }
    
    var displayTagName: String {
        if let customTag = customTag {
            return customTag.name
        } else {
            return tag.displayName
        }
    }
    
    var displayTagIcon: String {
        if let customTag = customTag {
            return customTag.icon
        } else {
            switch tag {
            case .todo: return "checkmark.circle.fill"
            case .idea: return "lightbulb.fill"
            case .tools: return "wrench.fill"
            case .general: return "note"
            }
        }
    }
    
    var displayTagColor: Color {
        if let customTag = customTag {
            return customTag.tagColor
        } else {
            return tag.color
        }
    }
}
