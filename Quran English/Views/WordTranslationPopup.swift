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

    var body: some View {
        VStack(spacing: 16) {
            // Arabic word
            Text(word.arabic)
                .font(.system(size: 36))
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Divider()

            // English translation
            VStack(alignment: .leading, spacing: 8) {
                Text("English Translation:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(word.englishTranslation)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Close button
            Button(action: onDismiss) {
                Text("Close")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
                .shadow(radius: 20)
        )
        .padding(40)
    }
}
