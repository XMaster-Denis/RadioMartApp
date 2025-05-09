//
//  ProjectSyncManager.swift
//  RadioMartApp
//
//  Created by XMaster on 10.04.25.
//

import Foundation
import FirebaseFirestore
import SwiftData

@MainActor
class ProjectSyncManager: ObservableObject {
    static let shared = ProjectSyncManager()
    
    var settingsManager = SettingsManager.shared
    var projectsManager = ProjectsManager.shared
    let db = FirebaseManager.shared.db
    
    private var mergeLocalProjectsWithCloud: Bool = false //Merge local projects with the cloud
    private let collectionName = "projects"
    private let context: ModelContext = DataBase.shared.modelContext
    private var syncTimer: Timer?
    
    @Published var showMergePrompt = false
    @Published var isWaitingForUserConfirmation = false
    @Published var pendingSyncContinuation: CheckedContinuation<Bool, Never>? = nil
    
    
    func requestMergeConfirmation() async -> Bool {
        
        
        
        return await withCheckedContinuation { continuation in
            self.pendingSyncContinuation = continuation
            self.showMergePrompt = true
        }
    }
    
    func syncProjectsBetweenLocalAndCloud() async {
        guard !isWaitingForUserConfirmation else {
            return
        }
        isWaitingForUserConfirmation = true
        
        print(" - syncProjectsBetweenLocalAndCloud")
        do {
            let localProjectsForDeleting = projectsManager.projectViewModelsAll.filter{
                $0.isMarkDeleted
            }
            
            for project in localProjectsForDeleting {
                projectsManager.deleteProject(project)
                if !project.userId.isEmpty {
                    await deleteProjectFromCloud(project.id)
                }
            }
            
            let localProjectsWithoutUserId = projectsManager.projectViewModels.filter{
                $0.userId == "" && !$0.isEmpty}
            
            
            let localProjectsWithoutUserIdAndEmpty = projectsManager.projectViewModels.filter{
                $0.userId == "" && $0.isEmpty
            }
            
            
            let localProjects = projectsManager.projectViewModels
            
            
            let remoteProjects = try await fetchRemoteProjects()
            
            if !localProjectsWithoutUserId.isEmpty && !remoteProjects.isEmpty {
                print("q1")
                let merge = await requestMergeConfirmation()
                if merge {
                    mergeLocalProjectsWithCloud = true
                } else {
                    mergeLocalProjectsWithCloud = false
                    print("q11")
                    for project in localProjectsWithoutUserIdAndEmpty {
                        print("DELETE 1")
                        projectsManager.markDeleteProject(project)
                    }
                }
            } else {
                print("q2")
                mergeLocalProjectsWithCloud = true
                for project in localProjectsWithoutUserIdAndEmpty {
                    print("DELETE 2")
                    projectsManager.markDeleteProject(project)
                }
                
            }
            

            
            

            
            print("localProjects - \(localProjects.count)")
            print("localProjectsWithoutUserId - \(localProjectsWithoutUserId.count)")

            print("localProjectsForDeleting - \(localProjectsForDeleting.count)")
            
            
            if let user = AuthManager.shared.user    {
                assignUserIdToLocalProjectsIfMissing(user.uid)
            }
            
            // Синхронизация: из Firebase в локальную базу
            if !remoteProjects.isEmpty {
                var newActiveProject: ProjectViewModel?
                for remoteDTO in remoteProjects {
                    if let local = localProjects.first(where: { $0.id == remoteDTO.id }) {
                        if remoteDTO.lastModified > local.lastModified {
                            print("q51")
                            updateLocalProject(local, with: remoteDTO)
                        }
                    } else {
                        print("q52")
                        newActiveProject = insertLocalProject(from: remoteDTO)
                    }
                }
                print("q53")
                if let newActiveProject {
                    print("q54")
                    settingsManager.updateActiveProject(to: newActiveProject)
                }
            }
            
            let unsyncedProjects = projectsManager.projectViewModelsAll.filter{
                !$0.isSyncedWithCloud && !$0.isMarkDeleted && !$0.userId.isEmpty
            }
            

//            let unsyncedProjects = try context.fetch(FetchDescriptor<Project>(predicate: #Predicate { !$0.isSyncedWithCloud && !$0.isMarkDeleted && !$0.userId.isEmpty }))
            
            
            print("unsyncedProjects - \(unsyncedProjects.count)")
            
            if mergeLocalProjectsWithCloud {
                for local in unsyncedProjects {
                    print("q6")
                    try await uploadLocalProjectToCloud(local)
                }
            }
            

            
        } catch {
            print("Ошибка синхронизации: \(error)")
        }
        isWaitingForUserConfirmation = false
    }
    
    
    private func deleteProjectFromCloud(_ projectId: String) async {
        do {
            try await db.collection(collectionName).document(projectId).delete()
            print("✅ Удалён проект из облака с id: \(projectId)")
        } catch {
            print("❌ Ошибка при удалении проекта из облака: \(error)")
        }
    }
    
    
    private func fetchRemoteProjects() async throws -> [ProjectDTO] {
        guard let userId = AuthManager.shared.userId else {return []}
        
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: ProjectDTO.self)
        }
        
    }
    
    
    
    
    
    private func uploadLocalProjectToCloud(_ project: ProjectViewModel) async throws {
        print(project.project.name)
        let dto = project.project.toDTO()
        
        try db.collection(collectionName).document(dto.id).setData(from: dto, merge: true) { error in
            if let error = error {
                print("123Ошибка при загрузке проекта в облако: \(error)")
            }
        }
        project.isSyncedWithCloud = true
    }
    
    private func insertLocalProject(from dto: ProjectDTO) -> ProjectViewModel {
        let items = dto.items.map {
            ItemProject(name: $0.name, count: $0.count, price: $0.price, idProductRM: $0.idProductRM)
        }
        let newProject = ProjectViewModel(Project(id: dto.id, name: dto.name, userId: AuthManager.shared.userId ?? "", itemsProject: items))
        newProject.lastModified = dto.lastModified
        newProject.userId = dto.userId
        newProject.isSyncedWithCloud = false
        ProjectsManager.shared.addNewProject(newProject)
        return newProject
    }
    
    private func updateLocalProject(_ local: ProjectViewModel, with dto: ProjectDTO) {
        local.name = dto.name
        local.lastModified = dto.lastModified
        local.userId = dto.userId
        local.itemsProject = dto.items.map {
            ItemProject(name: $0.name, count: $0.count, price: $0.price, idProductRM: $0.idProductRM)
        }
    }
    
    func startAutoSync(interval: TimeInterval = 5) {
        stopAutoSync()
        syncTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task {
                print("TIMER Projects")
                await self.syncProjectsBetweenLocalAndCloud()
                //                await self.syncUnsyncedProjectsToCloud()
            }
        }
    }
    
    func stopAutoSync() {
        syncTimer?.invalidate()
        syncTimer = nil
    }
    
    
    private func assignUserIdToLocalProjectsIfMissing(_ userId: String) {
        do {
            let projects = try context.fetch(FetchDescriptor<Project>(
                predicate: #Predicate { $0.userId == "" && !$0.isMarkDeleted})
            )
            for project in projects {
                if project.userId.isEmpty {
                    project.userId = userId
                    project.lastModified = Date()
                    project.isSyncedWithCloud = false
                }
            }
        } catch {
            print("Ошибка при обновлении userId в локальных проектах: \(error)")
        }
    }
    
}
