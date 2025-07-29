//
//  EmptyTimelineView.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/29.
//

import SwiftUI

struct EmptyTimelineView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [iOSDesignSystem.Colors.primary100.opacity(0.2), iOSDesignSystem.Colors.primary200.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "timeline.selection")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(iOSDesignSystem.Colors.primary100)
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("开始你的时间线")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("每次记录都会在这里形成时间线")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            Spacer()
        }
    }
}
