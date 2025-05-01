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

    

    
//    @MainActor
//    func deleteProject(_ deleteProject: Project)  {
//        modelContext.delete(deleteProject)
//    }
    
//    @MainActor
//    func removeSettings() {
//        modelContext.delete(getSettings())
//    }
    

    
    //    @MainActor
    //    func generateProject() {
    //        do {
    //            let result = try modelContext.fetch(FetchDescriptor<Project>())
    //            if result.isEmpty {
    //                let instance1 = Project(name: "First Project")
    //                modelContext.insert(instance1)
    //            }
    //        } catch {
    //            print("Project fetch error")
    //        }
    //    }
    /*
     if let result = try! modelContext.fetch(FetchDescriptor<Project>()).first {
     
     } else {
     let instance = Project(name: "Pro 1")
     modelContext.insert(instance)
     }
     */
    
//    @MainActor
//    func addNewProject(_ name: String) {
//        let instance = Project(name: name)
//        modelContext.insert(instance)
//    }
    
//    @MainActor
//    func totalProjectsCount() -> Int {
//        (try? modelContext.fetch(FetchDescriptor<Project>()).count) ?? 0
//    }
    
//    @MainActor
//    func getAllProjects() -> [Project] {
//        
//        do {
//            let result = try modelContext.fetch(FetchDescriptor<Project>())
//            if !result.isEmpty {
//                return result
//            } else {
//                let instance = Project(name: "Pro 1")
//                modelContext.insert(instance)
//                return [instance]
//            }
//        } catch {
//            fatalError("FetchDescriptor<Project>")
//        }
//
//    }
    
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
    
    //
    //    func appendItem(item: Settings) {
    //        modelContext.insert(item)
    //        do {
    //            try modelContext.save()
    //        } catch {
    //            fatalError(error.localizedDescription)
    //        }
    //    }
    
    //    func fetchItems() -> [Settings] {
    //        do {
    //            return try modelContext.fetch(FetchDescriptor<Settings>())
    //        } catch {
    //            fatalError(error.localizedDescription)
    //        }
    //    }
    

    
}
