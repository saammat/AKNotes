//
//  ContentView.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedFilter: NoteTag? = nil
    @State private var selectedTab = 0
    @StateObject private var noteStore = NoteStore()
    @State private var searchText = ""
    @State private var searchTag = ""
    @State private var noteToEdit: Note?
    
    @State private var showingSettings = false
    @State private var showingAddNote = false
    @State private var showingAddTag = false
    @State private var showingEditNote = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ZStack {
                    backgroundGradient
                    VStack {
                        VStack(spacing: 0) {
                            SearchBar(text: $searchText)
                                .padding(.horizontal, AppSpacing.md)
                                .padding(.top, AppSpacing.md)
                            
                            modernFilterSection
                                .padding(.vertical, AppSpacing.md)
                        }
                        let filteredNotes = getFilteredNotes()
                        ZStack(alignment: .bottomTrailing) {
                            if filteredNotes.isEmpty {
                                VStack {
                                    EmptyTimelineView()
                                    Spacer()
                                }
                            } else {
                                TimelineView(
                                    notes: filteredNotes,
                                    onDelete: { note in
                                        notesViewModel.deleteNote(note)
                                        HapticManager.shared.playSuccess()
                                    },
                                    onEdit: { note in
                                        noteToEdit = note
                                        showingEditNote = true
                                        HapticManager.shared.playSelection()
                                    }
                                )
                            }
                            
                            FloatingAddButton {
                                showingAddNote = true
                                HapticManager.shared.playSelection()
                            }
                            .padding(.trailing, AppSpacing.md)
                            .padding(.bottom, AppSpacing.xl)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("AkNotes")
                            .font(AppTypography.title)
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
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("笔记")
            }
            .tag(0)
            
            NavigationView {
                ZStack {
                    backgroundGradient
                    TagsListView()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("AkNotes")
                            .font(AppTypography.title)
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
            }
            .tabItem {
                Image(systemName: "tag")
                Text("标签")
            }
            .tag(2)
        }
        .onAppear(perform: setupTabBarAppearance)
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: notesViewModel)
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView { note in
                notesViewModel.addNote(note)
                showingAddNote = false
            } onCancel: {
                showingAddNote = false
            }
        }
        .sheet(isPresented: $showingAddTag) {
            AddTagView { tag in
                showingAddTag = false
            } onCancel: {
                showingAddTag = false
            }
        }
        .sheet(isPresented: $showingEditNote) {
            if let noteToEdit = noteToEdit {
                EditNoteView(viewModel: notesViewModel, note: noteToEdit)
            }
        }
    }
    
    private var backgroundGradient: some View {
        iOSDesignSystem.Colors.backgroundGradient.ignoresSafeArea()
    }
    
    private var modernFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "全部",
                    icon: "square.grid.2x2",
                    isSelected: selectedFilter == nil,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = nil
                            HapticManager.shared.playSelection()
                        }
                    },
                    color: iOSDesignSystem.Colors.accent200
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
                        },
                        color: iOSDesignSystem.Colors.accent200
                    )
                }
            }
            .padding(.horizontal, 16)
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
    
    private func handleAddAction() {
        if selectedTab == 0 || selectedTab == 1 {
            // From Notes tab or Add tab - add note
            showingAddNote = true
        } else if selectedTab == 2 {
            // From Tags tab - add tag
            showingAddTag = true
        }
    }
    
    private func getFilteredNotes() -> [Note] {
        let notes = notesViewModel.filterNotes(by: selectedFilter)
        
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { note in
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        tabBarAppearance.backgroundColor = UIColor(iOSDesignSystem.Colors.bg200).withAlphaComponent(0.8)
        
        // Configure item appearance
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(iOSDesignSystem.Colors.primary100)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(iOSDesignSystem.Colors.primary100),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        // Apply to both standard and scroll edge appearances
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16, weight: .medium))
            
            TextField("搜索笔记内容...", text: $text)
                .font(.system(.body, design: .rounded))
                .focused($isFocused)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.tertiarySystemFill))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isFocused ? iOSDesignSystem.Colors.accent200.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    let color: Color
    
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
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AnyShapeStyle(color) : AnyShapeStyle(Color(.tertiarySystemFill)))
            )
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    ContentView()
}
