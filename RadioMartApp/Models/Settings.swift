//
//  SettingsModel.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData

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
        //modelContext.insert(instance1)
        self.activProject = instance1
//        self.activProject = DataBase.shared.getAllProjects().first!
    }
//    init(activProject: Project? = nil, language: String = "en") {
//        self.activProject = activProject
//        self.language = language
//    }
    
//    public static func instance
    
    
}
