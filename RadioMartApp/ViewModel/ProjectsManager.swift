//
//  ProjectsManager.swift
//  RadioMartApp
//
//  Created by XMaster on 13.04.25.
//


import SwiftUI
import Combine
import SwiftData

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
    }
    
    @discardableResult
    func restart() -> ProjectViewModel {
        print("-------------restart")
        print(AuthManager.shared.userId ?? "No user id")
        let firstInstance = ProjectViewModel(Project(name: ProjectsManager.firstProjectName, userId: AuthManager.shared.userId), insertIfNeeded: true)
        deleteAllProjectsExcept(firstInstance)
        projectViewModelsAll = [firstInstance]
        SettingsManager.shared.updateActiveProject(to: firstInstance)
        return firstInstance
    }
    
    
    func deleteAllProjectsExcept(_ projectToKeep: ProjectViewModel) {
        let fetchDescriptor = FetchDescriptor<Project>()
        let allProjects = try? modelContext.fetch(fetchDescriptor)
        let projectsToDelete = allProjects?.filter { $0.id != projectToKeep.id } ?? []
        for project in projectsToDelete {
            modelContext.delete(project)
        }
        try? modelContext.save()
    }
    
    
    
    private func fetchProjects() {
        let projects = getAllProjectsSorted()
        projectViewModelsAll = projects.map { ProjectViewModel($0) }
    }
    
    
    func getAllProjectsSorted() -> [Project] {
        do {
            let descriptor = FetchDescriptor<Project>(
                sortBy: [SortDescriptor(\.lastModified, order: .forward)]
            )
            let result = try modelContext.fetch(descriptor)
            return result
        } catch {
            fatalError("Ошибка при сортировке проектов")
        }
    }
    
    func getProjectBy(id: String) -> ProjectViewModel {
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
    }
    
    
    func addNewProject(_ name: String) {
        let instance = ProjectViewModel(Project(name: name, userId: AuthManager.shared.userId))
        projectViewModelsAll.append(instance)
    }
    
    func addNewProject(_ project: ProjectViewModel) {
        projectViewModelsAll.append(project)
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
    }
    
    
    func markDeleteProject(_ project: ProjectViewModel) {
        if AuthManager.shared.authState == .signedOut {
            deleteProject(project)
        } else {
            
            project.isMarkDeleted = true
            
        }
        try? modelContext.save()
        
        
        let localProjectsForDeleting = projectViewModelsAll.filter{
            $0.isMarkDeleted == true
        }
        
        
    }
    
}
