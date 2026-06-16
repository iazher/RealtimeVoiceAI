//
//  MessageTests.swift
//  RealtimeVoiceAITests
//
//  Created by Iman Azher on 16/06/2026.

//  Unit tests for the Message model (Models/Message.swift).

import XCTest

@testable import RealtimeVoiceAI

// MARK: - Test class
final class MessageTests: XCTestCase {

    // MARK: Tests — initialisation

    func test_message_whenCreatedAsUserMessage_storesTextCorrectly() {
        let expectedText = "Hello, AI!"
        let message = Message(text: expectedText, isUser: true)
        
        XCTAssertEqual(message.text, expectedText, "Message text should match what was passed to the initialiser")
    }

    func test_message_whenCreatedAsUserMessage_isUserIsTrue() {
        let message = Message(text: "Hi", isUser: true)

        XCTAssertTrue(message.isUser, "isUser should be true for a user message")
    }

    func test_message_whenCreatedAsAIMessage_isUserIsFalse() {
        let message = Message(text: "Hello from AI", isUser: false)

        XCTAssertFalse(message.isUser, "isUser should be false for an AI message")
    }

    func test_message_allowsEmptyText() {
        // Edge case: the ViewModel creates an AI message with empty text first, then streams tokens into it. So empty text must be valid.
        let message = Message(text: "", isUser: false)

        XCTAssertEqual(message.text, "", "An empty string should be a valid message text")
    }

    // MARK: Tests — identity (UUID)

    func test_message_eachInstanceHasUniqueID() {
        // Two separate messages should NEVER share the same id.
        let messageA = Message(text: "Same text", isUser: true)
        let messageB = Message(text: "Same text", isUser: true)

        XCTAssertNotEqual(messageA.id, messageB.id, "Every message instance must get a unique UUID")
    }

    func test_message_idIsNotNil() {
        // UUID() never produces nil in Swift, but make sure any future refactor that changes 'id' to optional won't go unnoticed.
        let message = Message(text: "Test", isUser: true)

        // id is a UUID (non-optional) so we just assert it's a valid UUID by checking its string isn't empty.
        XCTAssertFalse(message.id.uuidString.isEmpty, "Message id must not be an empty UUID string")
    }

    // MARK: Tests — Equatable conformance

    func test_message_twoMessagesWithSameContentAreNotEqual() {
        let first  = Message(text: "Hi", isUser: true)
        let second = Message(text: "Hi", isUser: true)

        // They look the same but were created separately → different UUIDs
        XCTAssertNotEqual(first, second, "Two separately created messages should not be equal even with identical content")
    }

    func test_message_sameInstanceIsEqualToItself() {
        let message = Message(text: "Hi", isUser: true)

        // a == a must always be true
        XCTAssertEqual(message, message, "A message should be equal to itself")
    }

    // MARK: Tests — content edge cases

    func test_message_handlesLongText() {
        let longText = String(repeating: "word ", count: 500)
        let message = Message(text: longText, isUser: false)

        XCTAssertEqual(message.text.count, longText.count, "Message should store long text without truncation")
    }

    func test_message_handlesSpecialCharacters() {
        let specialText = "Hello 🤖\nNew line\t Tab \" Quote"
        let message = Message(text: specialText, isUser: true)

        XCTAssertEqual(message.text, specialText, "Message should preserve special characters, emojis, and whitespace exactly")
    }
}
