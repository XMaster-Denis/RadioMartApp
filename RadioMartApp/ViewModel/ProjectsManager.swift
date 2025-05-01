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
    
    @Published var projectViewModels: [ProjectViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        refreshProjects()
    }
    
    @discardableResult
    func restart() -> Project {
        print(AuthManager.shared.userId ?? "No user id")
        let firstInstance = Project(name: ProjectsManager.firstProjectName)
        SettingsManager.shared.updateActiveProject(to: firstInstance)
        deleteAllProjectsExcept(firstInstance)
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
    
    func deleteAllProjectsExcept(_ projectToKeep: Project) {
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
        
        for viewModel in projectViewModels {
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
        fetchProjects()
        subscribeToProjectsChanges()
    }
    
    private func fetchProjects() {
        let projects = getAllProjectsSorted()
        projectViewModels = projects.map { ProjectViewModel(project: $0) }
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
                predicate: #Predicate { !$0.isDeleted },
                sortBy: [SortDescriptor(\.lastModified, order: .forward)]
            )
            let result = try modelContext.fetch(descriptor)
            return result
        } catch {
            fatalError("Ошибка при сортировке проектов")
        }
    }
    
    func getProjectBy(id: String) -> Project {
        do {
            let descriptor = FetchDescriptor<Project>()
            let projects = try modelContext.fetch(descriptor)
            
            if projects.isEmpty {
                return restart()
            }
            
            if let project = projects.first(where: { $0.id == id }) {
                return project
            } else if let firstProject = projects.first {
                return firstProject
            } else {
                fatalError("Нет доступных проектов")
            }
        } catch {
            fatalError("Ошибка при получении проектов: \(error)")
        }
    }
    
    
    func addNewProject(_ name: String) {
        let instance = Project(name: name, userId: AuthManager.shared.userId)
        
        modelContext.insert(instance)
        try? modelContext.save()
        refreshProjects()
    }
      
    func addNewProject(_ project: Project) {
        modelContext.insert(project)
        try? modelContext.save()
        refreshProjects()
    }
    
    func deleteProject(_ deleteProject: Project) {
        // Если удаляемый проект активный, выбираем первый из оставшихся проектов
        if let allProjects = try? modelContext.fetch(FetchDescriptor<Project>()) {
            if allProjects.count <= 1 { return }
            if deleteProject == SettingsManager.shared.activProjectViewModel.project {
                if  let newActiveProject = allProjects.filter({ $0 != deleteProject }).first {
                    SettingsManager.shared.updateActiveProject(to: newActiveProject)
                }
            }
            // Удаляем проект
            
            modelContext.delete(deleteProject)
            try? modelContext.save()
            refreshProjects()
        }
    }
    
    func markDeleteProject(_ project: Project) {
        if AuthManager.shared.authState == .signedOut {
            deleteProject(project)
        } else {
            project.isDeleted = true
        }
        try? modelContext.save()
        refreshProjects()
    }
    
    func totalProjectsCount() -> Int {
        getAllProjectsSorted().count
    }
    
    // Методы добавления/удаления проектов можно реализовать здесь,
    // а после изменения данных вызывать fetchProjects() или обновлять projectViewModels напрямую.
}
