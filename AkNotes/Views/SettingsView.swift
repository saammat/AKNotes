//
//  SettingsView.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/29.
//

import SwiftUI

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
                    .foregroundColor(iOSDesignSystem.Colors.primary200)
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
