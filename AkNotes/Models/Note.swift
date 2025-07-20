import Foundation
import SwiftUI

enum NoteTag: String, CaseIterable, Codable {
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

struct Note: Identifiable, Codable {
    let id: UUID
    let content: String
    let tag: NoteTag
    let createdAt: Date
    
    init(id: UUID = UUID(), content: String, tag: NoteTag, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.tag = tag
        self.createdAt = createdAt
    }
    
    var formattedContent: String {
        "\(tag.rawValue)：\(content)"
    }
}