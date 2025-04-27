//
//  SettingsManager.swift
//  RadioMartApp
//
//  Created by XMaster on 13.04.25.
//

import SwiftUI
import Combine
import SwiftData


@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
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
    
    var activeProjectBinding: Binding<Project> {
        Binding(
            get: { self.activProjectViewModel.project },
            set: { newProject in
                self.activProjectViewModel.project = newProject
                self.activProjectViewModel.markModified()
            }
        )
    }

    func updateActiveProject(to newProject: Project) {
        settingsModel.activProject = newProject
        activProjectViewModel = ProjectViewModel(project: newProject)
        activProjectViewModel.markModified()
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
    

//    func removeSettings() {
//        modelContext.delete(getSettings())
//    }
}
