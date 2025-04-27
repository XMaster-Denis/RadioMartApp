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
    
    @Published var projectViewModels: [ProjectViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        refreshProjects()
    }
    
    func restart() {
        let firstInstance = Project(name: ProjectsManager.firstProjectName)
        SettingsManager.shared.updateActiveProject(to: firstInstance)
        deleteAllProjectsExcept(firstInstance)
        refreshProjects()
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
    
    func getAllProjects() -> [Project] {
        do {
            let result = try modelContext.fetch(FetchDescriptor<Project>())
            if !result.isEmpty {
                return result
            } else {
                let instance = Project(name: "Pro 1")
                modelContext.insert(instance)
                return [instance]
            }
        } catch {
            fatalError("FetchDescriptor<Project>")
        }

    }
    
    func getAllProjectsSorted() -> [Project] {
        do {
            let descriptor = FetchDescriptor<Project>(
                sortBy: [SortDescriptor(\.dateAdd, order: .reverse)]
            )
            let result = try modelContext.fetch(descriptor)
            return result
        } catch {
            fatalError("Ошибка при сортировке проектов")
        }
    }
    
    
    func addNewProject(_ name: String) {
        let instance = Project(name: name)
        
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
        if deleteProject == SettingsManager.shared.activProjectViewModel.project {
            if let allProjects = try? modelContext.fetch(FetchDescriptor<Project>()),
               let newActiveProject = allProjects.filter({ $0 != deleteProject }).first {
                SettingsManager.shared.updateActiveProject(to: newActiveProject)
            }
        }
        // Удаляем проект
        modelContext.delete(deleteProject)
        try? modelContext.save()
        refreshProjects()
    }
    
    func totalProjectsCount() -> Int {
        (try? modelContext.fetch(FetchDescriptor<Project>()).count) ?? 0
    }
    
    // Методы добавления/удаления проектов можно реализовать здесь,
    // а после изменения данных вызывать fetchProjects() или обновлять projectViewModels напрямую.
}
