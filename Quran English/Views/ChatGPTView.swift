//
//  ChatGPTView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatGPTView: View {
    let verse: QuranVerse
    @Environment(\.dismiss) var dismiss

    @State private var messages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var apiKey = ""
    @State private var showAPIKeyPrompt = true
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Verse Context
                VStack(alignment: .leading, spacing: 8) {
                    Text("Surah \(verse.surahNumber):\(verse.verseNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(verse.fullArabicText)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    Text(verse.fullEnglishTranslation)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))

                Divider()

                // Chat Messages
                if messages.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)

                        Text("Ask a question about this verse")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Example questions:")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("• What is the context of this verse?")
                                .font(.caption)
                            Text("• What lessons can we learn from this?")
                                .font(.caption)
                            Text("• How does this relate to daily life?")
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }

                                if isLoading {
                                    HStack {
                                        ProgressView()
                                            .padding(.horizontal, 8)
                                        Text("Thinking...")
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { _, _ in
                            if let lastMessage = messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }

                Divider()

                // Input Field
                HStack(spacing: 12) {
                    TextField("Ask a question...", text: $messageText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)

                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                    }
                    .disabled(messageText.isEmpty || isLoading)
                }
                .padding()
            }
            .navigationTitle("Ask ChatGPT")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("OpenAI API Key", isPresented: $showAPIKeyPrompt) {
                TextField("Enter your API key", text: $apiKey)
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Save") {
                    showAPIKeyPrompt = false
                }
            } message: {
                Text("Enter your OpenAI API key. It will be stored locally on your device only and never shared.")
            }
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }

        let userMessage = ChatMessage(text: messageText, isUser: true, timestamp: Date())
        messages.append(userMessage)
        let question = messageText
        messageText = ""

        isLoading = true

        // Simulate API call (replace with actual OpenAI API call)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let simulatedResponse = generateSimulatedResponse(for: question)
            let aiMessage = ChatMessage(text: simulatedResponse, isUser: false, timestamp: Date())
            messages.append(aiMessage)
            isLoading = false
        }
    }

    private func generateSimulatedResponse(for question: String) -> String {
        // This is a placeholder - replace with actual OpenAI API integration
        let responses = [
            "This placeholder response demonstrates how insights will appear once you connect a new knowledge source.",
            "Consider what themes or keywords stand out in this passage and how they relate to the project you have in mind.",
            "Try focusing on the structure of the text. What patterns or repeated ideas might inform your next revision?",
            "Add your own AI integration to replace this sample answer with domain-specific guidance."
        ]

        return responses.randomElement() ?? "Thanks for the question. Customize this view to hook into the content or service you plan to use."
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(uiColor: .systemGray5))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser { Spacer() }
        }
    }
}
