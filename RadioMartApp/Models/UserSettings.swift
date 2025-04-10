//
//  SettingsModel.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

@Model
final class Settings: ObservableObject {
    var activProject: Project
    var language: String
    var currentTab: Int
    
    @MainActor
    init( language: String = "en") {
        print("*set")
        self.language = language
        self.currentTab = 0
        let instance1 = Project(name: "First Project")
        self.activProject = instance1
    }
    
}

enum ContentLanguages: String, CaseIterable, Identifiable, Codable {
    case de = "German"
    case en = "English"
    case ru = "Russian"
    
    var id: Self { self }
    var code: String {"\(self)"}
}

struct UserSettingsFireBase: Codable, Identifiable {
    @DocumentID var id: String?
    
    var activProject: String
    var contentLanguage: ContentLanguages = .en
    var currentTab: Int = 0
    var yourCompanyName: String = "My Company"
    
    var userId: String
}

extension UserSettingsFireBase {
    static var empty: UserSettingsFireBase {
        UserSettingsFireBase(activProject: "", contentLanguage: ContentLanguages.de, currentTab: 0, yourCompanyName: "", userId: "")
    }
}
