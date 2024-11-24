////
////  OpenAI.swift
////  RadioMartApp
////
////  Created by XMaster on 06.09.2024.
////
//
//import Foundation
//import SwiftOpenAI
//
//class OpenAI {
//    static let shared = OpenAI()
//    
//    private lazy var service: OpenAIService = {
//        return OpenAIServiceFactory.service(apiKey: apiKey())
//    }()
//    
//    private func apiKey() -> String{
//        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
//           let keys = NSDictionary(contentsOfFile: path) as? [String: Any] {
//            let openAIKey = keys["OPENAI_API_KEY_PROJECT"] as? String
//            print("OpenAI API Key: \(openAIKey ?? "")")
//            return openAIKey ?? ""
//        }
//        return ""
//    }
//    
//    func askQuestion(prompt: String) async -> String {
//        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .custom("gpt-4o-mini"))
//        var result = ""
//        do {
//            let chatCompletionObject = try await service.startChat(parameters: parameters)
//            if let firstChoice = chatCompletionObject.choices.first {
//                result = firstChoice.message.content ?? "" // Сохраняем текстовый ответ
//            }
//        } catch APIError.responseUnsuccessful(let description) {
//           print("Network error with description: \(description)")
//        } catch {
//           print(error.localizedDescription)
//        }
//        return result
//    }
//    
//    
//    func run() async {
//        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text("hello world"))], model: .custom("gpt-4o-mini"))
//        do {
//            _ = try await service.startChat(parameters: parameters).choices
//           // Work with choices
//        } catch APIError.responseUnsuccessful(let description) {
//           print("Network error with description: \(description)")
//        } catch {
//           print(error.localizedDescription)
//        }
//    }
//    
//    private init (){}
//}
