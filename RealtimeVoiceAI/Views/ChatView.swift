//
//  ChatView.swift
//  RealtimeVoiceAI
//
//  Created by Iman Azher on 08/05/2026.
//

import SwiftUI

struct ChatView: View {

    @StateObject private var vm = VoiceAssistantViewModel()

    var body: some View {
        
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        
                        ForEach(vm.messages) { message in
                            
                            HStack {
                                
                                if message.isUser {
                                    Spacer()
                                }
                                
                                Text(message.text)
                                    .padding()
                                    .background(
                                        message.isUser
                                        ? Color.blue
                                        : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        message.isUser
                                        ? .white
                                        : .primary
                                    )
                                    .cornerRadius(16)
                                
                                if !message.isUser {
                                    Spacer()
                                }
                            }
                            .id(message.id)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: vm.messages) {
                    
                    guard let lastMessage = vm.messages.last else {
                        return
                    }

                    withAnimation(.smooth) {

                        proxy.scrollTo(
                            lastMessage.id,
                            anchor: .bottom
                        )
                    }
                }
                
                Spacer()
                
                if vm.isRecording {
                    
                    Text(vm.liveTranscript.isEmpty
                         ? "Listening..."
                         : vm.liveTranscript
                    )
                    .padding()
                    .foregroundColor(.secondary)
                }
                
                Button(action: {
                    vm.toggleRecording()
                }) {
                    
                    Circle()
                        .fill(vm.isRecording ? .red : .blue)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "mic.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 28))
                        )
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ChatView()
}
