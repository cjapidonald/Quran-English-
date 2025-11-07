//
//  TappableWordView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct TappableWordView: View {
    let word: QuranWord
    let onTap: (QuranWord) -> Void

    var body: some View {
        Text(word.arabic)
            .font(.system(size: 24))
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.clear)
            )
            .onTapGesture {
                onTap(word)
            }
    }
}
