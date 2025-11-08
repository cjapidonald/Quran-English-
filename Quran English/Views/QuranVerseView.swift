//
//  QuranVerseView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct QuranVerseView: View {
    let verse: QuranVerse
    @State private var selectedWord: QuranWord?
    @State private var showTranslation = false
    @State private var preferences = UserPreferences.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Verse number indicator (minimal, Apple Fitness style)
            HStack {
                Circle()
                    .fill(UserPreferences.accentGreen.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("\(verse.verseNumber)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(UserPreferences.accentGreen)
                    )
                Spacer()
            }

            // Arabic text with tappable words (right-to-left) - NO BOX
            FlowLayout(spacing: 6) {
                ForEach(Array((verse.words ?? []).enumerated()), id: \.element.position) { index, word in
                    TappableWordView(word: word) { tappedWord in
                        selectedWord = tappedWord
                        showTranslation = true
                    }
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .padding(.vertical, 8)

            // Full English translation - NO BOX, seamless
            Text(verse.fullEnglishTranslation)
                .font(.system(size: preferences.englishFontSize, weight: .regular, design: .default))
                .foregroundColor(preferences.textColor.opacity(0.85))
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .overlay(
            Group {
                if showTranslation, let word = selectedWord {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showTranslation = false
                            selectedWord = nil
                        }

                    WordTranslationPopup(word: word) {
                        showTranslation = false
                        selectedWord = nil
                    }
                }
            }
        )
    }
}

// FlowLayout for wrapping Arabic words
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
