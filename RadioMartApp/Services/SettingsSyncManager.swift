//
//  SettingsSyncManager.swift
//  RadioMartApp
//
//  Created by XMaster on 27.04.25.
//

import Foundation
import FirebaseFirestore
import SwiftData

@MainActor
class SettingsSyncManager {
    static let shared = SettingsSyncManager()
    
    let fb = FirebaseManager.shared.db
    private let collectionName = "user_settings"
    private let context: ModelContext = DataBase.shared.modelContext
    private var syncTimer: Timer?
    
    var settingsManager = SettingsManager.shared
    
    func ensureSettingsExists() async {
        guard AuthManager.shared.userId != nil else { return }

        await saveSettings()
    }
    
    
    func saveSettings() async {
        let localSettingsDTO = settingsManager.settingsModel.toDTO()
        guard let documentId = AuthManager.shared.userId else {return}
        do {
            try  fb.collection(collectionName).document(documentId).setData(from: localSettingsDTO, merge: true)
        } catch {
            print("saveSettings error: \(error.localizedDescription)")
        }
    }
    
    func fetchSettings() async {
        guard let documentId = AuthManager.shared.userId else {return}
        do {
            let fetchedSettings = try await fb.collection(collectionName).document(documentId).getDocument(as: SettingsDTO.self)
            await MainActor.run {
                settingsManager.updateFromDTO(fetchedSettings)
            }
        } catch {
            print("fetchSettings error: \(error.localizedDescription)")
        }
    }
    
    
    func startSettingsAutoSync(interval: TimeInterval = 5) {
        print("startSettingsAutoSync")
        stopSettingsAutoSync()
        syncTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task {
                await self.syncSettingsToCloud()
            }
        }
    }
    
    func stopSettingsAutoSync() {
        syncTimer?.invalidate()
        syncTimer = nil
    }
    
    func syncSettingsToCloud() async {
        if !settingsManager.isSyncedWithCloud {
            print("saveSettings")
            await saveSettings()
            settingsManager.isSyncedWithCloud = true
        }
        
    }
}
