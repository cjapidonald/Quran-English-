//
//  DesignSystem.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

// MARK: - Color Palette (Apple Fitness Style)
struct AppColors {
    // Dark theme backgrounds
    static let darkBackground = Color(red: 0.07, green: 0.07, blue: 0.09)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.15).opacity(0.8)
    static let glassBackground = Color(red: 0.15, green: 0.15, blue: 0.18).opacity(0.6)

    // Vibrant accent colors
    static let neonGreen = Color(red: 0.0, green: 1.0, blue: 0.6)
    static let neonPink = Color(red: 1.0, green: 0.2, blue: 0.6)
    static let neonCyan = Color(red: 0.0, green: 0.8, blue: 1.0)
    static let neonYellow = Color(red: 1.0, green: 0.9, blue: 0.0)
    static let neonPurple = Color(red: 0.7, green: 0.3, blue: 1.0)
    static let neonOrange = Color(red: 1.0, green: 0.5, blue: 0.0)

    // Text colors
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.6)
    static let tertiaryText = Color.white.opacity(0.4)
}

// MARK: - Glass Card Modifier
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.5)
            )
    }
}

// MARK: - Vibrant Button Style
struct VibrantButtonStyle: ButtonStyle {
    var color: Color
    var fullWidth: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.5), radius: configuration.isPressed ? 5 : 10, x: 0, y: configuration.isPressed ? 2 : 5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - Neon Ring (for Surah numbers)
struct NeonRing: View {
    let number: Int
    let color: Color
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [color, color.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: size, height: size)
                .shadow(color: color.opacity(0.6), radius: 8, x: 0, y: 0)

            Text("\(number)")
                .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
    }
}

// MARK: - View Extensions
extension View {
    func glassCard(cornerRadius: CGFloat = 20, padding: CGFloat = 16) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, padding: padding))
    }

    func vibrantButton(color: Color, fullWidth: Bool = false) -> some View {
        buttonStyle(VibrantButtonStyle(color: color, fullWidth: fullWidth))
    }
}

// MARK: - Gradient Backgrounds
struct GradientBackground: View {
    var colors: [Color]

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
