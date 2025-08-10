import Foundation
import SwiftUI

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
