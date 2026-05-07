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

    func toggleRecording() {

        isRecording.toggle()

        if isRecording {

            print("Started Recording")

        } else {

            print("Stopped Recording")

            let fakeUserText = "Hello AI" // fake user input

            messages.append(
                Message(
                    text: fakeUserText,
                    isUser: true
                )
            )

            messages.append(
                Message(
                    text: "Hello human!!", // fake response
                    isUser: false
                )
            )
        }
    }
}
