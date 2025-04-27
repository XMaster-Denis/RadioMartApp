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
class ProjectSyncManager {
    static let shared = ProjectSyncManager()

    let db = FirebaseManager.shared.db
    private let collectionName = "projects"
    private let context: ModelContext = DataBase.shared.modelContext
    private var syncTimer: Timer?

    func syncProjectsBetweenLocalAndCloud() async {
        do {
            let localProjects = try context.fetch(FetchDescriptor<Project>())
            let remoteProjects = try await fetchRemoteProjects()

            // Синхронизация: из Firebase в локальную базу
            for remoteDTO in remoteProjects {
                if let local = localProjects.first(where: { $0.id == remoteDTO.id }) {
                    if remoteDTO.lastModified > local.lastModified {
                        updateLocalProject(local, with: remoteDTO)
                    }
                } else {
                    insertLocalProject(from: remoteDTO)
                }
            }

            // Синхронизация: из локальной базы в Firebase
            print("1")
            //print(localProjects.first?.userId)
            print(UserSettingsFireBaseViewModel.shared.settings.userId)
            for local in localProjects { //where local.userId == UserSettingsFireBaseViewModel.shared.settings.userId {
                print("2")
                print(local.userId)
                if let remote = remoteProjects.first(where: { $0.id == local.id }) {
                    if local.lastModified > remote.lastModified {
                        print("3")
                        try await uploadLocalProjectToCloud(local)
                    }
                } else {
                    print("4")
                    try await uploadLocalProjectToCloud(local)
                }
            }
        } catch {
            print("Ошибка синхронизации1: \(error)")
        }
    }

    private func fetchRemoteProjects() async throws -> [ProjectDTO] {
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: UserSettingsFireBaseViewModel.shared.settings.userId)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: ProjectDTO.self)
        }
    }

    private func uploadLocalProjectToCloud(_ project: Project) async throws {
        let dto = project.toDTO(userId: project.userId)
        print("!!")
        print(dto.userId)
        print(project.userId)
        
        print("!!!!")
        
        try db.collection(collectionName).document(dto.id).setData(from: dto, merge: true) { error in
            if let error = error {
                print("123Ошибка при загрузке проекта в облако: \(error)")
            }
        }
        project.isSyncedWithCloud = true
    }

    private func insertLocalProject(from dto: ProjectDTO) {
        let items = dto.items.map {
            ItemProject(name: $0.name, count: $0.count, price: $0.price, idProductRM: $0.idProductRM)
        }
        let newProject = Project(name: dto.name, itemsProject: items)
        newProject.id = dto.id
        newProject.lastModified = dto.lastModified
        newProject.userId = dto.userId
        newProject.isSyncedWithCloud = false
        ProjectsManager.shared.addNewProject(newProject)
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
                print("TIMER")
                await self.syncUnsyncedProjectsToCloud()
            }
        }
    }

    func stopAutoSync() {
        syncTimer?.invalidate()
        syncTimer = nil
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
