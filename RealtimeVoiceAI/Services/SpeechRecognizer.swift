//
//  SpeechRecognizer.swift
//  RealtimeVoiceAI
//
//  Created by Iman Azher on 08/05/2026.
//

import Foundation
import Speech
import AVFoundation
internal import Combine

final class SpeechRecognizer: NSObject, ObservableObject {

    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    @Published var transcript = ""

    func requestPermissions() async -> Bool {

        let speechAuth = await withCheckedContinuation {
            continuation in

            SFSpeechRecognizer.requestAuthorization {
                status in

                continuation.resume(returning: status)
            }
        }

        let micAuth = await withCheckedContinuation {
            continuation in

            AVAudioSession.sharedInstance().requestRecordPermission {
                granted in

                continuation.resume(returning: granted)
            }
        }

        return speechAuth == .authorized && micAuth
    }

    func startRecording() throws {
        
        transcript = ""
        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()

        try audioSession.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: .duckOthers
        )

        try audioSession.setActive(true)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest else {
            throw NSError(domain: "Recognition Request Error", code: 1)
        }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        recognitionTask = speechRecognizer?.recognitionTask(
            with: recognitionRequest
        ) { [weak self] result, error in

            guard let self else { return }

            if let result = result {

                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }

            if error != nil {

                self.stopRecording()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { buffer, _ in

            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()

        try audioEngine.start()
    }

    func stopRecording() {

        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
}
