import SwiftUI

struct FloatingAddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(
                        colors: [iOSDesignSystem.Colors.primary100, iOSDesignSystem.Colors.primary200],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: 1)
    }
}

struct FloatingAddButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingAddButton {
                    print("Add button tapped")
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
    }
}
