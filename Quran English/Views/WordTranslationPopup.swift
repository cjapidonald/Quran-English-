//
//  WordTranslationPopup.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct WordTranslationPopup: View {
    let word: QuranWord
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            // Top accent bar
            HStack {
                Circle()
                    .fill(UserPreferences.accentGreen)
                    .frame(width: 8, height: 8)

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 8)

            // Arabic word - Large and centered
            Text(word.arabic)
                .font(.custom("GeezaPro", size: 52))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .shadow(color: UserPreferences.accentGreen.opacity(0.3), radius: 10, x: 0, y: 0)

            // Subtle divider with gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            UserPreferences.accentGreen.opacity(0.3),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)

            // English translation section
            VStack(alignment: .leading, spacing: 12) {
                Text("Translation")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(UserPreferences.accentGreen)
                    .textCase(.uppercase)
                    .tracking(1.2)

                Text(word.englishTranslation)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)

            // Tap anywhere to close hint
            Text("Tap anywhere to close")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.4))
                .padding(.bottom, 16)
        }
        .frame(maxWidth: 340)
        .background(
            // Glassmorphism effect
            ZStack {
                // Dark translucent background with blur
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.7),
                                        Color(red: 0.1, green: 0.1, blue: 0.15).opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )

                // Subtle border with gradient
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                UserPreferences.accentGreen.opacity(0.5),
                                UserPreferences.accentGreen.opacity(0.1),
                                Color.white.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )

                // Top highlight for glass effect
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.15),
                                .clear
                            ]),
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            }
        )
        .shadow(color: UserPreferences.accentGreen.opacity(0.2), radius: 30, x: 0, y: 10)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(40)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
