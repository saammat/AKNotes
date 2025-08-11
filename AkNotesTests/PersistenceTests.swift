import Foundation
import SwiftUI
import Testing

@testable import AkNotes

@Suite struct PersistenceTests {
    
    @Test func testNotesPersistence() async throws {
        let viewModel = NotesViewModel()
        
        // Clear existing notes
        viewModel.clearAllNotes()
        #expect(viewModel.notes.isEmpty)
        
        // Add a test note
        let testNote = Note(content: "Test note", tag: .general)
        viewModel.addNote(testNote)
        #expect(viewModel.notes.count == 1)
        #expect(viewModel.notes[0].content == "Test note")
        
        // Create new instance to test persistence
        let newViewModel = NotesViewModel()
        // Wait a bit for async loading
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(newViewModel.notes.count == 1)
        #expect(newViewModel.notes[0].content == "Test note")
        
        // Clean up
        newViewModel.clearAllNotes()
    }
    
    @Test func testTagsPersistence() async throws {
        let viewModel = TagsViewModel()
        
        // Clear existing tags
        viewModel.customTags.removeAll()
        viewModel.saveTags()
        
        // Add a test tag
        let testTag = CustomTag(name: "Test Tag", icon: "star")
        viewModel.addTag(testTag)
        #expect(viewModel.customTags.count == 1)
        #expect(viewModel.customTags[0].name == "Test Tag")
        
        // Create new instance to test persistence
        let newViewModel = TagsViewModel()
        // Wait a bit for async loading
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(newViewModel.customTags.count == 1)
        #expect(newViewModel.customTags[0].name == "Test Tag")
        
        // Clean up
        newViewModel.customTags.removeAll()
        newViewModel.saveTags()
    }
    
    @Test func testCustomTagCodable() throws {
        let tag = CustomTag(name: "Test Tag", icon: "star", color: "#FF0000")
        
        // Test encoding
        let encoder = JSONEncoder()
        let data = try encoder.encode(tag)
        #expect(!data.isEmpty)
        
        // Test decoding
        let decoder = JSONDecoder()
        let decodedTag = try decoder.decode(CustomTag.self, from: data)
        #expect(decodedTag.name == tag.name)
        #expect(decodedTag.icon == tag.icon)
        #expect(decodedTag.color == tag.color)
    }
}