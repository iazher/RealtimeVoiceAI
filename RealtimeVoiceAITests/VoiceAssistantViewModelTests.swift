//
//  VoiceAssistantViewModelTests.swift
//  RealtimeVoiceAITests
//
//  Created by Iman Azher on 17/06/2026.

import XCTest
import Combine
@testable import RealtimeVoiceAI

@MainActor
final class VoiceAssistantViewModelTests: XCTestCase {

    // MARK: Properties
    
    var sut: VoiceAssistantViewModel!
    var cancellables = Set<AnyCancellable>()

    // MARK: Lifecycle

    override func setUp() async throws {
        try await super.setUp()
        sut = VoiceAssistantViewModel()
    }

    override func tearDown() async throws {
        cancellables.removeAll()
        sut = nil
        try await super.tearDown()
    }

    // MARK: Tests — initial state

    func test_initialState_messagesIsEmpty() {
        // Brand new ViewModel should have no messages.
        XCTAssertTrue(sut.messages.isEmpty, "messages should be empty on initialisation")
    }

    func test_initialState_isRecordingIsFalse() {
        XCTAssertFalse(sut.isRecording, "Recording should not be active on initialisation")
    }

    func test_initialState_liveTranscriptIsEmpty() {
        XCTAssertEqual(sut.liveTranscript, "", "liveTranscript should be empty on initialisation")
    }

    // MARK: Tests — toggleRecording (start)

    func test_toggleRecording_whenNotRecording_setsIsRecordingTrue() {
        // Precondition: not recording
        XCTAssertFalse(sut.isRecording)
        
        sut.toggleRecording()
        
        XCTAssertTrue(sut.isRecording, "Calling toggleRecording() while idle should start recording")
    }

    func test_toggleRecording_whenAlreadyRecording_setsIsRecordingFalse() {
        // First tap → start
        sut.toggleRecording()
        XCTAssertTrue(sut.isRecording)

        // Second tap → stop
        sut.toggleRecording()

        XCTAssertFalse(sut.isRecording, "Calling toggleRecording() while recording should stop recording")
    }

    func test_toggleRecording_canToggleMultipleTimes() {
        // Simulate repeated taps. The flag should keep flipping cleanly
        sut.toggleRecording() // → true
        sut.toggleRecording() // → false
        sut.toggleRecording() // → true

        XCTAssertTrue(sut.isRecording, "After three toggles the recording flag should be true")
    }

    // MARK: Tests — stopRecording / message creation
    // When recording stops with a non-empty transcript, the ViewModel should:
    //   1. Add a user message
    //   2. Add an (initially empty) AI message
    //   3. Clear liveTranscript
    //   4. Set isRecording = false

    func test_stopRecording_withTranscript_addsUserMessage() async throws {
        sut.toggleRecording()                      // start
        sut.liveTranscript = "Tell me a joke"      // simulate recognised speech
        sut.toggleRecording()                      // stop → triggers stopRecording()

        await Task.yield()

        XCTAssertFalse(sut.messages.isEmpty, "Stopping recording with a transcript should add at least one message")

        let userMessage = sut.messages.first
        XCTAssertEqual(userMessage?.text, "Tell me a joke", "First message should contain the transcript text")
        XCTAssertTrue(userMessage?.isUser == true, "First message should be marked as a user message")
    }

    func test_stopRecording_withTranscript_addsAIPlaceholderMessage() async throws {
        sut.toggleRecording()
        sut.liveTranscript = "What is Swift?"
        sut.toggleRecording()

        await Task.yield()

        // There should be 2 messages: user + AI placeholder
        XCTAssertGreaterThanOrEqual(sut.messages.count, 2, "Should have at least a user message and an AI placeholder after stopping")

        let aiMessage = sut.messages.last
        XCTAssertFalse(aiMessage?.isUser == true, "The second message should be the AI's (isUser = false)")
    }

    func test_stopRecording_clearsLiveTranscript() async throws {
        sut.toggleRecording()
        sut.liveTranscript = "Some speech"
        sut.toggleRecording()

        await Task.yield()

        XCTAssertEqual(sut.liveTranscript, "", "liveTranscript should be cleared after recording stops")
    }

    func test_stopRecording_withEmptyTranscript_doesNotAddMessages() async throws {
        sut.toggleRecording()
        sut.liveTranscript = "   "  // whitespace only
        sut.toggleRecording()

        await Task.yield()

        XCTAssertTrue(sut.messages.isEmpty, "Stopping with a blank transcript should not add any messages")
    }

    func test_stopRecording_withEmptyTranscript_doesNotAddMessages_strictlyEmpty() async throws {
        sut.toggleRecording()
        sut.liveTranscript = ""  // fully empty
        sut.toggleRecording()

        await Task.yield()

        XCTAssertTrue(sut.messages.isEmpty, "Stopping with an empty transcript should not add any messages")
    }

    // MARK: Tests — message ordering

    func test_messages_userMessageAppearsBeforeAIMessage() async throws {
        sut.toggleRecording()
        sut.liveTranscript = "Hello!"
        sut.toggleRecording()

        await Task.yield()

        guard sut.messages.count >= 2 else {
            XCTFail("Expected at least 2 messages")
            return
        }

        XCTAssertTrue(sut.messages[0].isUser, "User message should come first")
        XCTAssertFalse(sut.messages[1].isUser, "AI message should come second")
    }
    
    // MARK: Tests — @Published state changes

    func test_liveTranscript_updatesWhenSet() {
        sut.liveTranscript = "Hello World"
        XCTAssertEqual(sut.liveTranscript, "Hello World", "liveTranscript should immediately reflect the new value")
    }
    
    func test_isRecording_isTrueAfterToggle() {
        sut.toggleRecording()
        XCTAssertTrue(sut.isRecording, "isRecording should be true immediately after the first toggle")
    }

    // MARK: Tests — multiple conversation turns

    func test_multipleRecordingCycles_accumulateMessages() async throws {
        // First turn
        sut.toggleRecording()
        sut.liveTranscript = "First question"
        sut.toggleRecording()
        await Task.yield()

        // Second turn
        sut.toggleRecording()
        sut.liveTranscript = "Second question"
        sut.toggleRecording()
        await Task.yield()

        // Each turn adds 2 messages (user + AI), so 2 turns = at least 4
        XCTAssertGreaterThanOrEqual(sut.messages.count, 4, "Two recording cycles should add at least 4 messages total")
    }

    func test_multipleRecordingCycles_messagesAreInCorrectOrder() async throws {
        sut.toggleRecording()
        sut.liveTranscript = "Turn one"
        sut.toggleRecording()
        await Task.yield()

        sut.toggleRecording()
        sut.liveTranscript = "Turn two"
        sut.toggleRecording()
        await Task.yield()

        guard sut.messages.count >= 4 else {
            XCTFail("Expected at least 4 messages")
            return
        }

        // Pattern: user, AI, user, AI ...
        XCTAssertTrue(sut.messages[0].isUser)
        XCTAssertFalse(sut.messages[1].isUser)
        XCTAssertTrue(sut.messages[2].isUser)
        XCTAssertFalse(sut.messages[3].isUser)
    }
}
