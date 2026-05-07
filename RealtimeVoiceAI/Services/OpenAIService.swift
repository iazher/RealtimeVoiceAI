//
//  OpenAIService.swift
//  RealtimeVoiceAI
//
//  Created by Iman Azher on 08/05/2026.
//

import Foundation

final class OpenAIService {

    // TODO: Add OpenAI API key here 
    private let apiKey = ""

    func streamResponse(
        userMessage: String,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void
    ) async throws {

        guard let url = URL(
            string: "https://api.openai.com/v1/chat/completions"
        ) else {
            return
        }

        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "messages": [
                [
                    "role": "user",
                    "content": userMessage
                ]
            ],
            "stream": true
        ]

        let jsonData = try JSONSerialization.data(
            withJSONObject: body
        )

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "Bearer \(apiKey)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.httpBody = jsonData

        let (bytes, response) = try await URLSession.shared.bytes(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse else {

            print("Not an HTTP response")
            return
        }

        print("Status Code:", httpResponse.statusCode)

        if httpResponse.statusCode != 200 {

            print("Request Failed")
            return
        }

        for try await line in bytes.lines {

            if line.hasPrefix("data: ") {

                let data = line.dropFirst(6)

                if data == "[DONE]" {

                    await MainActor.run {
                        onComplete()
                    }

                    break
                }

                guard let jsonData = data.data(
                    using: .utf8
                ) else {
                    continue
                }

                do {

                    if let json = try JSONSerialization.jsonObject(
                        with: jsonData
                    ) as? [String: Any],

                    let choices = json["choices"] as? [[String: Any]],

                    let delta = choices.first?["delta"]
                        as? [String: Any],

                    let content = delta["content"] as? String {

                        await MainActor.run {
                            onToken(content)
                        }
                    }

                } catch {

                    print(error.localizedDescription)
                }
            }
        }
    }
}
