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
    private var deleteLocalProjects: Bool = false //Merge local projects with the cloud
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

            let unsyncedProjects = try context.fetch(FetchDescriptor<Project>(predicate: #Predicate { !$0.isSyncedWithCloud }))
          //  var needsUpdate: Bool = false
            
            let emptyLocalProjects = try context.fetch(FetchDescriptor<Project>(predicate: #Predicate { $0.itemsProject.isEmpty }))
            
            let localProjectsWithoutUserId = try context.fetch(FetchDescriptor<Project>(
                predicate: #Predicate { $0.userId == "" && !$0.itemsProject.isEmpty })
            )
            
            let localProjectsForDeleting = try context.fetch(FetchDescriptor<Project>(
                predicate: #Predicate { $0.isDeleted })
            )
            
            let localProjects = try context.fetch(FetchDescriptor<Project>())
            
            print("localProjects - \(localProjects.count)")
            print("emptyLocalProjects - \(emptyLocalProjects.count)")
            print("localProjectsWithoutUserId - \(localProjectsWithoutUserId.count)")
            print("unsyncedProjects - \(unsyncedProjects.count)")
            
            let remoteProjects = try await fetchRemoteProjects()
            
            if !localProjectsWithoutUserId.isEmpty && !remoteProjects.isEmpty {
                print("q1")
                let merge = await requestMergeConfirmation()
                if merge {
                    mergeLocalProjectsWithCloud = true
                    deleteLocalProjects = false
                } else {
                    mergeLocalProjectsWithCloud = false
                    deleteLocalProjects = true
                }
                
            } else {
                print("q2")
                mergeLocalProjectsWithCloud = true
                deleteLocalProjects = false
//                if remoteProjects.isEmpty && !localProjects.isEmpty {
//                    print("q21")
//                    mergeLocalProjectsWithCloud = true
//                    deleteLocalProjects = false
//                } else {
//                    print("q22")
//                    mergeLocalProjectsWithCloud = false
//                    deleteLocalProjects = false
//                }
            }
            
            


            
            if let user = AuthManager.shared.user    {
                assignUserIdToLocalProjectsIfMissing(user.uid)
            }
            
            // Синхронизация: из Firebase в локальную базу
            if !remoteProjects.isEmpty {
                var newActiveProject: Project?
                for remoteDTO in remoteProjects {
                    if let local = localProjects.first(where: { $0.id == remoteDTO.id }) {
                        newActiveProject = local
                        if remoteDTO.lastModified > local.lastModified {
                            print("q51")
                            updateLocalProject(local, with: remoteDTO)
                      //      needsUpdate = true
                        }
                    } else {
                        print("q52")
                        newActiveProject = insertLocalProject(from: remoteDTO)
                    }
                }
                guard let newActiveProject else {return}
                settingsManager.updateActiveProject(to: newActiveProject)
            }
            //
            
            if mergeLocalProjectsWithCloud {
                for local in unsyncedProjects {
                    print("q6")
                    try await uploadLocalProjectToCloud(local)
//                    //where local.userId ==
//                    if let remote = remoteProjects.first(where: { $0.id == local.id }) {
//                      //  if local.lastModified > remote.lastModified {
//                            print("q61")
//                            try await uploadLocalProjectToCloud(local)
//                      //  }
//                    } else {
//                        print("q62")
//                        try await uploadLocalProjectToCloud(local)
//                    }
                }
            }
            
            for project in localProjectsForDeleting {
                projectsManager.deleteProject(project)
                await deleteProjectFromCloud(project.id)
            }
            
//            if deleteLocalProjects {
//               for local in localProjects {
//                   projectsManager.deleteProject(local)
//               }
//           }
            
//            for emptyLocalProject in emptyLocalProjects {
//                print("q3")
//                projectsManager.deleteProject(emptyLocalProject)
//            }
            
         //   if needsUpdate {
//            projectsManager.refreshProjects()
          //  }
            
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
        
         

    

    private func uploadLocalProjectToCloud(_ project: Project) async throws {
        let dto = project.toDTO(userId: project.userId)
//        print("!!")
//        print(dto.userId)
//        print(project.userId)
//        
//        print("!!!!")
        
        try db.collection(collectionName).document(dto.id).setData(from: dto, merge: true) { error in
            if let error = error {
                print("123Ошибка при загрузке проекта в облако: \(error)")
            }
        }
        project.isSyncedWithCloud = true
    }
    
    private func insertLocalProject(from dto: ProjectDTO) -> Project {
        let items = dto.items.map {
            ItemProject(name: $0.name, count: $0.count, price: $0.price, idProductRM: $0.idProductRM)
        }
        let newProject = Project(id: dto.id, name: dto.name, userId: AuthManager.shared.userId ?? "", itemsProject: items)
        newProject.lastModified = dto.lastModified
        newProject.userId = dto.userId
        newProject.isSyncedWithCloud = false
        ProjectsManager.shared.addNewProject(newProject)
        return newProject
    }

    private func updateLocalProject(_ local: Project, with dto: ProjectDTO) {
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
                predicate: #Predicate { $0.userId == ""})
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

    func syncUnsyncedProjectsToCloud() async {
        do {
            let unsyncedProjects =   try context.fetch(FetchDescriptor<Project>(predicate: #Predicate { !$0.isSyncedWithCloud }))
            
            for project in unsyncedProjects {
                print("Projecr for Sink \(project.name)")
                try await uploadLocalProjectToCloud(project)
                project.isSyncedWithCloud = true
            }
        } catch {
            print("Ошибка авто-синхронизации: \(error)")
        }
    }
}
