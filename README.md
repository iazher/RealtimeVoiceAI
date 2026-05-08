A realtime AI-powered voice assistant built with SwiftUI, Combine, and OpenAI streaming APIs.

RealtimeVoiceAI delivers a low-latency conversational experience by streaming AI responses token-by-token, creating a smooth and responsive interaction similar to modern AI assistants. 

## Features
- Realtime AI response streaming
- Token-by-token incremental rendering
- Speech-to-text architecture
- Swift Concurrency (async/await)
- Combine-based reactive state management
- Modern SwiftUI chat interface
- Voice assistant style interaction flow
- MVVM architecture
- Simulator-compatible speech simulation mode

## Demo

<table>
  <tr>
    <td align="center">
      <img width="301.5" height="655.5" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-08 at 01 41 52" src="https://github.com/user-attachments/assets/ef6e303a-0223-452a-a736-44dbffa789a2" />
      <br/>
      <b>Voice Input</b>
    </td>
    <td align="center">
      <img width="301.5" height="655.5" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-08 at 01 41 59" src="https://github.com/user-attachments/assets/882b10aa-840a-4f24-b1d6-b0280f3b9613" />
      <br/>
      <b>Streaming AI Response</b>
    </td>
  </tr>
</table>

## Tech Stack

iOS 
- SwiftUI
- Combine
- AVFoundation
- Speech Framework
- Swift Concurrency

AI
- OpenAI API
- Streaming Chat Completions
- Incremental token rendering

## ARCHITECTURE 

    UI Layer
     ├── ChatView
     ├── Voice Button
     └── Streaming Message Renderer

    ViewModels
     └── VoiceAssistantViewModel

    Services
     ├── OpenAIService
     ├── SpeechRecognizer
     └── Streaming Handler

    Models
     └── Message

## Realtime Streaming Flow

             User Message
                  ↓   
          OpenAI Streaming API
                  ↓
             Token Stream
                  ↓
            Live UI Updates
                  ↓
    Realtime Conversational Experience

The app streams AI responses incrementally instead of waiting for a full completion, significantly improving perceived responsiveness and user experience.

## Current Functionality

- Simulated realtime speech transcription
- Streaming AI responses
- Dynamic chat updates
- Reactive SwiftUI rendering
- Realtime conversational UI

## Future Improvements

- Real microphone speech recognition (when have real device for testing)
- AI voice playback
- Animated waveform visualization
- Auto-scrolling chat
- Latency metrics dashboard
- Conversation persistence
- On-device caching
- Dark mode polish
- Multi-model selection

## Getting Started

Requirements
- Xcode 16+
- iOS 18+
- OpenAI API Key

## Setup

Clone the repository:

    git clone https://github.com/imanazher/RealtimeVoiceAI.git

Open the project in Xcode.

Add your OpenAI API key inside:

    OpenAIService.swift

    private let apiKey = "YOUR_API_KEY"

Run the app on simulator or physical device.

## Learning Outcomes

This project was built to explore:
- Realtime AI interaction systems
- Streaming network architectures
- Low-latency rendering
- Reactive UI patterns
- Modern iOS concurrency
- AI-first mobile UX design

## Author

Iman Azher
