//
//  LocalizationManager.swift
//  RadioMartApp
//
//  Created by XMaster on 30.03.25.
//
import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()

    var selectedLanguage: String {
        UserSettingsFireBaseViewModel.shared.settings.contentLanguage.code
    }

    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main // fallback
        }
        return bundle
    }
}
