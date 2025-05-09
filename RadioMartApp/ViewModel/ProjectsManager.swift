//
//  ProjectsManager.swift
//  RadioMartApp
//
//  Created by XMaster on 13.04.25.
//


import SwiftUI
import Combine
import SwiftData

//@ObservedObject var projectsManager = ProjectsManager.shared

@MainActor
final class ProjectsManager: ObservableObject {
    static let shared = ProjectsManager()
    
    static let firstProjectName: String = "First project"
    let modelContext = DataBase.shared.modelContext
    
    @Published var projectViewModelsAll: [ProjectViewModel] = []
    
    var projectViewModels: [ProjectViewModel] {
        projectViewModelsAll.filter{
            !$0.isMarkDeleted
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        fetchProjects()
        //refreshProjects()
    }
    
    @discardableResult
    func restart() -> ProjectViewModel {
        print("-------------restart")
        print(AuthManager.shared.userId ?? "No user id")
        let firstInstance = ProjectViewModel(Project(name: ProjectsManager.firstProjectName,userId: AuthManager.shared.userId))
        deleteAllProjectsExcept(firstInstance)
        projectViewModelsAll = [firstInstance]
        refreshProjects()
        return firstInstance
    }
    
    //    func removeAllProjects() {
    //        do {
    //            try DataBase.shared.modelContext.delete(model: Project.self)
    //        } catch {
    //            print("Failed to clear all Project data.")
    //        }
    //    }
    
    func deleteAllProjectsExcept(_ projectToKeep: ProjectViewModel) {
        let fetchDescriptor = FetchDescriptor<Project>()
        let allProjects = try? modelContext.fetch(fetchDescriptor)
        let projectsToDelete = allProjects?.filter { $0.id != projectToKeep.id } ?? []
        for project in projectsToDelete {
            modelContext.delete(project)
        }
        refreshProjects()
        try? modelContext.save()
    }
    
    private func subscribeToProjectsChanges() {
        print("subscribeToProjectsChanges")
        // Отменяем старые подписки, если они были
        cancellables.removeAll()
        
        for viewModel in projectViewModelsAll {
            print("add")
            viewModel.objectWillChange
                .sink { [weak self] _ in
                    print("ccccc")
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    func refreshProjects() {
        
        subscribeToProjectsChanges()
    }
    
    private func fetchProjects() {
        print("fetchProjects")
        let projects = getAllProjectsSorted()
        projectViewModelsAll = projects.map { ProjectViewModel($0) }
    }
    
    //    func getAllProjects() -> [Project] {
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
    
    func getAllProjectsSorted() -> [Project] {
        do {
            let descriptor = FetchDescriptor<Project>(
//                predicate: #Predicate { !$0.isDeleted },
                sortBy: [SortDescriptor(\.lastModified, order: .forward)]
            )
            let result = try modelContext.fetch(descriptor)
            return result
        } catch {
            fatalError("Ошибка при сортировке проектов")
        }
    }
    
    func getProjectBy(id: String) -> ProjectViewModel {
        //        do {
        //            let descriptor = FetchDescriptor<Project>()
        //            let projects = try modelContext.fetch(descriptor)
        //
        if projectViewModels.isEmpty {
            return restart()
        }
        
        if let project = projectViewModels.first(where: { $0.id == id }) {
            return project
        } else if let firstProject = projectViewModels.first {
            return firstProject
        } else {
            fatalError("Нет доступных проектов")
        }
        //        } catch {
        //            fatalError("Ошибка при получении проектов: \(error)")
        //        }
    }
    
    
    func addNewProject(_ name: String) {
        let instance = ProjectViewModel(Project(name: name, userId: AuthManager.shared.userId))
        projectViewModelsAll.append(instance)
//                modelContext.insert(instance)
//                try? modelContext.save()
        refreshProjects()
    }
    
    func addNewProject(_ project: ProjectViewModel) {
        projectViewModelsAll.append(project)
//                modelContext.insert(project)
//                try? modelContext.save()
        refreshProjects()
    }
    
    func deleteProject(_ deleteProject: ProjectViewModel) {
        if projectViewModels.count == 1 &&
            deleteProject === projectViewModels.first { return }
        if deleteProject == SettingsManager.shared.currentProjectViewModel {
            if  let newActiveProject = projectViewModels.filter({ $0 != deleteProject }).first {
                SettingsManager.shared.updateActiveProject(to: newActiveProject)
            }
        }

        
        projectViewModelsAll.removeAll { $0.id == deleteProject.id }
        
        modelContext.delete(deleteProject.project)
        try? modelContext.save()
        refreshProjects()
    }
    
    
    func markDeleteProject(_ project: ProjectViewModel) {
        if AuthManager.shared.authState == .signedOut {
            deleteProject(project)
        } else {

            project.isMarkDeleted = true

        }
        try? modelContext.save()
 
        
        let localProjectsForDeleting = projectViewModelsAll.filter{
            $0.isMarkDeleted == true //"+"
        }
        
        print(localProjectsForDeleting)

    }

}
