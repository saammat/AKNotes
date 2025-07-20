//
//  ContentView.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var selectedFilter: NoteTag? = nil
    @State private var showingSettings = false
    @State private var showingEditNote = false
    @State private var showingAddNote = false
    @State private var noteToEdit: Note?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
                
                mainContent
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("AkNotes")
                        .font(AppTypography.title3)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingEditNote) {
                if let noteToEdit = noteToEdit {
                    EditNoteView(viewModel: viewModel, note: noteToEdit)
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteModal(viewModel: viewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var backgroundGradient: some View {
        AppColors.appBackgroundGradient
            .ignoresSafeArea()
    }
    
    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            // Notes list only
            modernNotesList
            
            // Floating add button
            FloatingAddButton {
                showingAddNote = true
                HapticManager.shared.playSelection()
            }
            .padding(.bottom, 30)
        }
    }
    
    private var modernFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "全部",
                    icon: "square.grid.2x2",
                    isSelected: selectedFilter == nil,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = nil
                            HapticManager.shared.playSelection()
                        }
                    }
                )
                
                ForEach(NoteTag.allCases, id: \.self) { tag in
                    FilterChip(
                        title: tag.displayName,
                        icon: tagIcon(for: tag),
                        isSelected: selectedFilter == tag,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedFilter = selectedFilter == tag ? nil : tag
                                HapticManager.shared.playSelection()
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private var modernNotesList: some View {
        VStack(spacing: 0) {
            // Filter section at top
            modernFilterSection
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.md)
            
            // Timeline notes
            let filteredNotes = viewModel.filterNotes(by: selectedFilter)
            
            if filteredNotes.isEmpty {
                VStack {
                    EmptyTimelineView()
                    Spacer()
                }
            } else {
                TimelineView(
                    notes: filteredNotes,
                    onDelete: { note in
                        viewModel.deleteNote(note)
                        HapticManager.shared.playSuccess()
                    },
                    onEdit: { note in
                        noteToEdit = note
                        showingEditNote = true
                        HapticManager.shared.playSelection()
                    }
                )
            }
        }
    }
    
    private func tagIcon(for tag: NoteTag) -> String {
        switch tag {
        case .todo: return "checkmark.circle"
        case .idea: return "lightbulb"
        case .tools: return "wrench"
        case .general: return "note"
        }
    }
}

struct FloatingAddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(title)
                    .font(.system(.callout, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color(.secondarySystemFill))
            )
        }
        .buttonStyle(.plain)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAllAlert = false
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("应用信息") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("数据") {
                    Button("清空所有笔记") {
                        showingDeleteAllAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .alert("确认删除", isPresented: $showingDeleteAllAlert) {
                Button("删除", role: .destructive) {
                    viewModel.clearAllNotes()
                    dismiss()
                }
                Button("取消", role: .cancel) { }
            } message: {
                Text("此操作将删除所有笔记，无法撤销。确定要清空所有笔记吗？")
            }
        }
    }
}

#Preview {
    ContentView()
}
