//
//  NoteTagEnum.swift
//  AkNotes
//
//  Created by 徐 on 2025/8/10.
//
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
        case .general: return "其他"
        }
    }
    
    var color: Color {
        switch self {
        case .todo: return .red
        case .idea: return .blue
        case .tools: return .green
        case .general: return .gray
        }
    }
}
