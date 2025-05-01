//
//  SettingsManager.swift
//  RadioMartApp
//
//  Created by XMaster on 13.04.25.
//

import SwiftUI
import Combine
import SwiftData

// @ObservedObject var settingsManager = SettingsManager.shared

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    var isSyncedWithCloud: Bool = false
    @Published var settingsModel: SettingsModel
    @Published var activProjectViewModel: ProjectViewModel
    let modelContext = DataBase.shared.modelContext

    init() {
        self.settingsModel = SettingsManager.getSettings()
        self.activProjectViewModel = ProjectViewModel(project: SettingsManager.getSettings().activProject)
    }
    
    var currentTab: Binding<Int> {
        Binding(
            get: { self.settingsModel.currentTab },
            set: { newValue in
                self.settingsModel.currentTab = newValue
                try? self.modelContext.save()
            }
        )
    }
    
    var contentLanguage: Binding<ContentLanguages> {
        Binding(
            get: { self.settingsModel.contentLanguage },
            set: { newValue in
                self.settingsModel.contentLanguage = newValue
                LM.shared.currentLanguage = newValue
                self.isSyncedWithCloud = false
                try? self.modelContext.save()
            }
        )
    }
    
    var companyName: Binding<String> {
        Binding(
            get: { self.settingsModel.companyName },
            set: { newValue in
                self.settingsModel.companyName = newValue
                self.isSyncedWithCloud = false
                try? self.modelContext.save()
            }
        )
    }
    
    var activeProjectBinding: Binding<Project> {
        Binding(
            get: { self.activProjectViewModel.project },
            set: { newProject in
                self.activProjectViewModel.project = newProject
                self.activProjectViewModel.markModified()
                self.isSyncedWithCloud = false
            }
        )
    }

    func updateActiveProject(to newProject: Project) {
        settingsModel.activProject = newProject
        activProjectViewModel = ProjectViewModel(project: newProject)
        isSyncedWithCloud = false
    }
    
    static func getSettings() -> SettingsModel {
        if let settings = try! DataBase.shared.modelContext.fetch(FetchDescriptor<SettingsModel>()).first{
            return settings
        } else {
            
            let settings = SettingsModel()
            DataBase.shared.modelContext.insert(settings)
            return settings
        }
    }
    
    func updateFromDTO(_ dto: SettingsDTO) {
        let activProject =  ProjectsManager.shared.getProjectBy(id: dto.activProjectId)
        updateActiveProject(to: activProject)
        companyName.wrappedValue = dto.companyName
        if let language = ContentLanguages(rawValue: dto.languageCode) {
            contentLanguage.wrappedValue = language
        } else {
            contentLanguage.wrappedValue = .en
        }
        
        
    }
    

//    func removeSettings() {
//        modelContext.delete(getSettings())
//    }
}
