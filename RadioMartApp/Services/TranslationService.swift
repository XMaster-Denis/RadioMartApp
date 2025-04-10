import Foundation
import Alamofire

struct TranslationRequestData: Codable {
    let words: [String]
    let targetLanguage: String
    let contentType: ContentType
}

struct TranslationResponseData: Codable {
    let translatedText: [String]
}

enum ContentType: String, Codable {
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
    
    func apiKey() -> String {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return (keys["TRANSLATE_KEY"] as? String) ?? ""
        }
        return ""
    }
    
    let translationRequest = TranslationRequestData(words: words, targetLanguage: targetLanguage, contentType: contentType)
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(apiKey())",
        "Content-Type": "application/json",
        "TranslationType": "json"
    ]
    
    let responseData = try await AF.request(
        url,
        method: .post,
        parameters: translationRequest,
        encoder: JSONParameterEncoder.default,
        headers: headers
    ).serializingData().value
    
    let translationResponse = try JSONDecoder().decode(TranslationResponseData.self, from: responseData)
    
    guard !translationResponse.translatedText.isEmpty else {
        return words
    }
    
    return translationResponse.translatedText
}
