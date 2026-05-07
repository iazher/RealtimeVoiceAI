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
            //try speechRecognizer.startRecording()
            simulateSpeech() // for testing on simulator 
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func simulateSpeech() {

        isRecording = true

        liveTranscript = ""

        let words = [
            "Hello",
            "how",
            "are",
            "you",
            "today"
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

        liveTranscript = ""
    }
}
