//
//  SplashView.swift
//  AkNotes
//
//  Created by Claude on 2025/8/10.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 40) {
                // 应用图标
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    Image("AppIconImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .scaleEffect(size)
                        .rotationEffect(.degrees(size > 0.9 ? 0 : -10))
                }
                
                // 应用名称
                VStack(spacing: 8) {
                    Text("AkNotes")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(opacity)
                    
                    Text("简洁优雅的笔记应用")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(opacity)
                }
                .offset(y: size > 0.9 ? 0 : 20)
            }
        }
        .onAppear {
            // 启动动画
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                self.size = 1.0
                self.opacity = 1.0
            }
            
            // 延时后跳转到主界面
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.6)) {
                    self.isActive = true
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                iOSDesignSystem.Colors.primary200,
                iOSDesignSystem.Colors.primary200.opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView(isActive: .constant(false))
}
