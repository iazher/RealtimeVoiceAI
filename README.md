# RealtimeVoiceAI 

Realtime AI-powered voice assistant built with SwiftUI, Combine, and OpenAI streaming APIs.RealtimeVoiceAI delivers a low-latency conversational experience by streaming AI responses token-by-token, creating a smooth and responsive interaction similar to modern AI assistants.

# Features

- Realtime AI response streaming
- Token-by-token incremental rendering
- Speech-to-text architecture
- Swift Concurrency (`async/await`)
- Combine-based reactive state management
- Modern SwiftUI chat interface
- Animated waveform visualization
- Auto-scrolling chat
- Voice assistant style interaction flow
- MVVM architecture
- Simulator-compatible speech simulation mode

# Demo

https://github.com/user-attachments/assets/fc3bbd67-91c1-4303-abb5-e68077a5d814


# Tech Stack

## iOS
- SwiftUI
- Combine
- AVFoundation
- Speech Framework
- Swift Concurrency

## AI
- OpenAI API
- Streaming Chat Completions
- Incremental token rendering



# ARCHITECTURE 

    UI Layer
     ├── ChatView
     ├── Voice Button
     ├── WaveformView
     └── Streaming Message Renderer

    ViewModels
     └── VoiceAssistantViewModel

    Services
     ├── OpenAIService
     ├── SpeechRecognizer
     └── Streaming Handler

    Models
     └── Message

# Realtime Streaming Flow

             User Message
                  ↓   
          OpenAI Streaming API
                  ↓
             Token Stream
                  ↓
            Live UI Updates
                  ↓
    Realtime Conversational Experience

The app streams AI responses incrementally instead of waiting for a full completion, significantly improving perceived responsiveness and conversational fluidity.

# Current Functionality

- Simulated realtime speech transcription
- Streaming AI responses
- Dynamic chat updates
- Animated waveform visualization
- Auto-scrolling chat
- Reactive SwiftUI rendering
- Realtime conversational UI

# Future Improvements

- Real microphone speech recognition (when have real device for testing)
- AI voice playback
- Latency metrics dashboard
- Conversation persistence
- On-device caching
- Dark mode polish
- Multi-model selection

# Getting Started

Requirements
- Xcode 16+
- iOS 18+
- OpenAI API Key

# Setup

Clone the repository:

    git clone https://github.com/iazher/RealtimeVoiceAI.git

Open the project in Xcode.

Add your OpenAI API key inside:

    OpenAIService.swift

    private let apiKey = "YOUR_API_KEY"

Run the app on simulator or physical device.

# Learning Outcomes

This project was built to explore:
- Realtime AI interaction systems
- Streaming network architectures
- Low-latency rendering
- Reactive UI patterns
- Modern iOS concurrency
- AI-first mobile UX design
- Realtime streaming UX engineering

# Author

Iman Azher
