//
//  ContentView.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/19.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedFilter: NoteTag? = nil
    @State private var selectedCustomTag: CustomTag? = nil
    @State private var selectedTab = 0
    @StateObject private var noteStore = NoteStore()
    @State private var searchText = ""
    @State private var searchTag = ""
    @State private var noteToEdit: Note?
    @State private var customTags: [CustomTag] = []
    @State private var deletedPredefinedTagIds: Set<UUID> = []
    @State private var customTagToDelete: CustomTag?
    @State private var showingDeleteAlert = false
    
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
                        ZStack(alignment: .bottomTrailing) {
                            if getFilteredNotes().isEmpty {
                                VStack {
                                    EmptyTimelineView()
                                    Spacer()
                                }
                            } else {
                                TimelineView(
                                    notes: getFilteredNotes(),
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
                .navigationBarItems(leading: 
                    Text("AkNotes")
                        .font(AppTypography.title)
                        .foregroundColor(.primary),
                    trailing:
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                )
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("笔记")
            }
            .tag(0)
            
            NavigationView {
                ZStack {
                    backgroundGradient
                    TagsListView(
                        onAddTag: {
                            showingAddTag = true
                            HapticManager.shared.playSelection()
                        },
                        onDeleteTag: { tag in
                            customTagToDelete = tag
                            showingDeleteAlert = true
                        },
                        allTags: getAllTags(),
                        notes: notesViewModel.notes
                    )
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: 
                    Text("AkNotes")
                        .font(AppTypography.title)
                        .foregroundColor(.primary),
                    trailing:
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                )
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
            AddNoteView(
                onSave: { note in
                    notesViewModel.addNote(note)
                    showingAddNote = false
                },
                onCancel: {
                    showingAddNote = false
                },
                customTags: customTags
            )
        }
        .sheet(isPresented: $showingAddTag) {
            AddTagView { customTag in
                customTags.append(customTag)
                showingAddTag = false
                HapticManager.shared.playSuccess()
            } onCancel: {
                showingAddTag = false
            }
        }
        .sheet(isPresented: $showingEditNote) {
            if let noteToEdit = noteToEdit {
                EditNoteView(viewModel: notesViewModel, note: noteToEdit, customTags: customTags)
            }
        }
        .alert("删除标签", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) {
                customTagToDelete = nil
            }
            Button("删除", role: .destructive) {
                if let customTagToDelete = customTagToDelete {
                    // 首先尝试从自定义标签中删除
                    if let index = customTags.firstIndex(where: { $0.id == customTagToDelete.id }) {
                        customTags.remove(at: index)
                        HapticManager.shared.playSuccess()
                    } else {
                        // 如果不是自定义标签，则添加到已删除的预定义标签集合中
                        deletedPredefinedTagIds.insert(customTagToDelete.id)
                        HapticManager.shared.playSuccess()
                    }
                }
                customTagToDelete = nil
            }
        } message: {
            if let customTagToDelete = customTagToDelete {
                Text("确定要删除标签\"\(customTagToDelete.name)\"吗？此操作不可撤销。")
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
                    isSelected: selectedFilter == nil && selectedCustomTag == nil,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = nil
                            selectedCustomTag = nil
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
                                if selectedFilter != nil {
                                    selectedCustomTag = nil
                                }
                                HapticManager.shared.playSelection()
                            }
                        },
                        color: iOSDesignSystem.Colors.accent200
                    )
                }
                
                ForEach(customTags, id: \.id) { customTag in
                    FilterChip(
                        title: customTag.name,
                        icon: customTag.icon,
                        isSelected: isCustomTagSelected(customTag),
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                toggleCustomTagSelection(customTag)
                                HapticManager.shared.playSelection()
                            }
                        },
                        color: customTag.tagColor
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
        var notes: [Note]
        
        if let selectedFilter = selectedFilter {
            notes = notesViewModel.filterNotes(by: selectedFilter)
        } else if let selectedCustomTag = selectedCustomTag {
            notes = notesViewModel.filterNotes(by: selectedCustomTag)
        } else {
            notes = notesViewModel.notes
        }
        
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { note in
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func getAllTags() -> [CustomTag] {
        let predefinedTags: [CustomTag] = [
            CustomTag(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "待办", icon: "checkmark.circle.fill", color: "#FF6B6B"),
            CustomTag(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "想法", icon: "lightbulb.fill", color: "#4ECDC4"),
            CustomTag(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, name: "工具", icon: "wrench.fill", color: "#667eea"),
            CustomTag(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, name: "一般", icon: "note", color: "#8E8E93")
        ]
        let activePredefinedTags = predefinedTags.filter { !deletedPredefinedTagIds.contains($0.id) }
        return activePredefinedTags + customTags
    }
    
    private func isCustomTagSelected(_ customTag: CustomTag) -> Bool {
        return selectedCustomTag?.id == customTag.id
    }
    
    private func toggleCustomTagSelection(_ customTag: CustomTag) {
        if selectedCustomTag?.id == customTag.id {
            selectedCustomTag = nil
        } else {
            selectedCustomTag = customTag
            selectedFilter = nil
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
