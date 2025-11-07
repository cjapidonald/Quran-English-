//
//  ChatGPTView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct ChatGPTView: View {
    let verse: QuranVerse
    @Environment(\.dismiss) private var dismiss
    @State private var userQuestion = ""
    @State private var chatMessages: [ChatMessage] = []
    @State private var isLoading = false
    @State private var apiKey = ""

    var body: some View {
        NavigationView {
            VStack {
                // Verse reference
                VStack(spacing: 8) {
                    Text("Surah \(verse.surahNumber), Verse \(verse.verseNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(verse.fullArabicText)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text(verse.fullEnglishTranslation)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                .padding()

                Divider()

                // Chat messages
                ScrollView {
                    VStack(spacing: 12) {
                        if chatMessages.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)

                                Text("Ask a question about this verse")
                                    .font(.headline)
                                    .foregroundColor(.secondary)

                                Text("Example: What is the meaning of this verse?\nWhat lessons can we learn from this verse?")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 40)
                        } else {
                            ForEach(chatMessages) { message in
                                ChatMessageRow(message: message)
                            }
                        }
                    }
                    .padding()
                }

                // Input area
                VStack {
                    if apiKey.isEmpty {
                        VStack(spacing: 8) {
                            Text("Enter your OpenAI API Key")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            SecureField("API Key", text: $apiKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)

                            Text("Your key is stored locally and never shared")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack {
                        TextField("Ask a question...", text: $userQuestion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(isLoading || apiKey.isEmpty)

                        Button(action: sendQuestion) {
                            if isLoading {
                                ProgressView()
                            } else {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(userQuestion.isEmpty || apiKey.isEmpty ? .gray : .blue)
                            }
                        }
                        .disabled(userQuestion.isEmpty || isLoading || apiKey.isEmpty)
                    }
                    .padding()
                }
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
        }
    }

    private func sendQuestion() {
        guard !userQuestion.isEmpty, !apiKey.isEmpty else { return }

        let question = userQuestion
        userQuestion = ""

        // Add user message
        let userMessage = ChatMessage(text: question, isUser: true)
        chatMessages.append(userMessage)

        isLoading = true

        // Call ChatGPT API (placeholder - you'll need to implement this with actual API call)
        Task {
            do {
                let response = try await callChatGPTAPI(question: question, verse: verse, apiKey: apiKey)
                let aiMessage = ChatMessage(text: response, isUser: false)
                await MainActor.run {
                    chatMessages.append(aiMessage)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    let errorMessage = ChatMessage(text: "Sorry, I couldn't process your request. Please check your API key and try again.", isUser: false)
                    chatMessages.append(errorMessage)
                    isLoading = false
                }
            }
        }
    }

    private func callChatGPTAPI(question: String, verse: QuranVerse, apiKey: String) async throws -> String {
        // Placeholder for actual ChatGPT API call
        // You'll need to implement this with URLSession and your OpenAI API key

        let prompt = """
        Verse: \(verse.fullArabicText)
        Translation: \(verse.fullEnglishTranslation)

        Question: \(question)
        """

        // This is a placeholder response
        // In production, replace this with actual API call
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate delay

        return "This is a placeholder response. To enable ChatGPT integration, you'll need to implement the OpenAI API call with your API key. The verse you're asking about is from Surah \(verse.surahNumber), Verse \(verse.verseNumber)."
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp = Date()
}

struct ChatMessageRow: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(uiColor: .secondarySystemBackground))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(12)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser {
                Spacer()
            }
        }
    }
}
