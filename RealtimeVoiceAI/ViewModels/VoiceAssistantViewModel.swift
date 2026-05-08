//
//  VoiceAssistantViewModel.swift
//  RealtimeVoiceAI
//
//  Created by Iman Azher on 08/05/2026.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
final class VoiceAssistantViewModel: ObservableObject {

    @Published var messages: [Message] = []
    @Published var isRecording = false
    @Published var liveTranscript = ""
    

    private let speechRecognizer = SpeechRecognizer()
    private let openAIService = OpenAIService()

    init() {

        Task {
            _ = await speechRecognizer.requestPermissions()
        }

        speechRecognizer.$transcript
            .receive(on: RunLoop.main)
            .assign(to: &$liveTranscript)
    }

    func toggleRecording() {

        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {

        do {
            isRecording = true
            // TODO: use the startRecording method for testing on real device and comment out simulateSpeech()
            // try speechRecognizer.startRecording()
            simulateSpeech() // for testing on simulator
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func simulateSpeech() {

        isRecording = true

        liveTranscript = ""
        
        let words = [
            "write",
            "an",
            "essay",
            "of",
            "180",
            "words",
            "on any",
            "topic"
        ]

        Task {

            for word in words {
                try? await Task.sleep(for: .milliseconds(400))
                liveTranscript += word + " "
            }
        }
    }

    private func stopRecording() {
        
        isRecording = false
        speechRecognizer.stopRecording()
        
        let finalText = liveTranscript.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !finalText.isEmpty else { return }

        messages.append(
            Message(
                text: finalText,
                isUser: true
            )
        )
        
        let aiMessage = Message(
            text: "",
            isUser: false
        )

        messages.append(aiMessage)

        let aiIndex = messages.count - 1

        Task {

            do {

                try await openAIService.streamResponse(
                    userMessage: finalText
                ) { token in

                    self.messages[aiIndex] = Message(
                        text: self.messages[aiIndex].text + token,
                        isUser: false
                    )

                } onComplete: {

                    print("Streaming Complete")
                }

            } catch {

                print(error.localizedDescription)
            }
        }

        liveTranscript = ""
    }
}
