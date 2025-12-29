//
//  LocalizationManager.swift
//  RadioMartApp
//
//  Created by XMaster on 30.03.25.
//
import Foundation


class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published  var currentLanguage: ContentLanguages
    
    init () {

        let systemCode = Locale.preferredLanguages.first?
            .prefix(2)
            .lowercased()

        let detected = ContentLanguages(code: systemCode)
            ?? .en
        self.currentLanguage = detected
    }
    
    
    static var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: LM.shared.currentLanguage.code, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }
        return bundle
    }
}
