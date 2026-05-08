//
//  WaveformView.swift
//  RealtimeVoiceAI
//
//  Created by Iman Azher on 08/05/2026.
//

import Foundation
import SwiftUI

struct WaveformView: View {

    @State private var animate = false

    let barCount = 6

    var body: some View {

        HStack(spacing: 6) {
            
            ForEach(0..<barCount, id: \.self) { index in
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(
                        width: 6,
                        height: animate ? CGFloat.random(in: 20...70) : 20
                    )
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever()
                        .delay(Double(index) * 0.05),
                        value: animate
                    )
            }
        }
        .foregroundStyle(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    WaveformView()
}
