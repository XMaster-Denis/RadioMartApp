//  SettingsModel.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

@Model
final class SettingsModel {
    var id: String = UUID().uuidString
    @Relationship var activProject: Project
    var contentLanguage: ContentLanguages
    var currentTab: Int
    var companyName: String

    
    @MainActor
    init( contentLanguage: ContentLanguages = .de) {
        print("*set")
        self.contentLanguage = contentLanguage
        self.currentTab = 0
        let firstInstance = Project(name: ProjectsManager.firstProjectName,userId: AuthManager.shared.userId)
        activProject = firstInstance
        companyName = "My Company"
    }
    
    @MainActor
    func toDTO() -> SettingsDTO {
        guard let userId = AuthManager.shared.userId else {
            fatalError("UserId not set in toDTO")
            
        }

        return SettingsDTO(
            id: self.id,
            userId: userId,
            activProjectId: self.activProject.id,
            languageCode: self.contentLanguage.code,
            currentTab: self.currentTab,
            companyName: self.companyName
            )
        }
}


