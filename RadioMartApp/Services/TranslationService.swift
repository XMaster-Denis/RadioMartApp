//
//  TranslationRequestData.swift
//  RadioMartApp
//
//  Created by XMaster on 16.11.24.
//


import Foundation

struct TranslationRequestData: Codable {
    let words: [String]
    let targetLanguage: String
    let contentType: ContentType
}

struct TranslationResponseData: Codable {
    let translatedText: [String]
}


enum ContentType: String, Codable
{
    case word
    case html
}

enum TranslationServiceError: Error {
    case invalidResponse
    case invalidData
}

func fetchTranslation(words: [String], targetLanguage: String, contentType: ContentType) async throws -> [String] {
    
    let url: URL = {
        if let dbURL = ProcessInfo.processInfo.environment["DB"] {
            return URL(string: dbURL)!
        } else {
            return URL(string: "https://tools.radiomart.kz/translate")!
        }
    }()

    func apiKey() -> String{
            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
               let keys = NSDictionary(contentsOfFile: path) as? [String: Any] {
                let translateKey = keys["TRANSLATE_KEY"] as? String
                return translateKey ?? ""
            }
            return ""
        }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey())", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("json", forHTTPHeaderField: "TranslationType")

    let translationRequest = TranslationRequestData(words: words, targetLanguage: targetLanguage, contentType: contentType)
    request.httpBody = try JSONEncoder().encode(translationRequest)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print ("Error receiving transfer!!!")
        throw URLError(.badServerResponse)
    }

    let translationResponse = try JSONDecoder().decode(TranslationResponseData.self, from: data)
    
    guard !translationResponse.translatedText.isEmpty else  {return words}

    return translationResponse.translatedText
}

