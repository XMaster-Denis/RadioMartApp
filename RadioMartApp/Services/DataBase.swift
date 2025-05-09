//
//  DataBase.swift
//  RadioMartApp
//
//  Created by XMaster on 16.12.2023.
//

import SwiftUI
import SwiftData

class DataBase {
    
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    private let modelConfiguration: ModelConfiguration
    let schema = Schema([
        Project.self,
        ItemProject.self,
        SettingsModel.self
    ])
    
    
    @MainActor
    static let shared = DataBase()
    
    @MainActor
    private init() {
        self.modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)
        do{
            self.modelContainer = try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            print("Error Create ModelContainer - \(error)")
            fatalError()
        }
        self.modelContext = modelContainer.mainContext
    }

    
    @MainActor
    func getAllUnsyncedProjects() -> [Project] {
        do {
            let result = try modelContext.fetch(FetchDescriptor<Project>())
            if !result.isEmpty {
                return result
            } else {
                return []
            }
        } catch {
            fatalError("FetchDescriptor<Project>")
        }
    }
    


    
}
