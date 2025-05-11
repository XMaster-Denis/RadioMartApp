//
//  FirebaseManager.swift
//  RadioMartApp
//
//  Created by XMaster on 11.04.25.
//


import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db: Firestore
    
    private init() {
        self.db = Firestore.firestore()
    }
}
