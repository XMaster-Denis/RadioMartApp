//
//  Project.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData
import FlowPDF
import PDFKit

@Model
final class Project: ObservableObject {
    var id: String
    var name: String
    var userId: String
    var lastModified: Date
    var isSyncedWithCloud: Bool
    var dateAdd: Date
    @Relationship(deleteRule: .cascade) var itemsProject = [ItemProject]()
    var isMarkDeleted: Bool
    
    init(id: String = UUID().uuidString, name: String, userId: String? = "", itemsProject: [ItemProject] = [],  ) {
        self.id = id
        self.name = name
        self.itemsProject = itemsProject
        self.dateAdd = .now
        self.lastModified = .now
        self.isSyncedWithCloud = false
        self.userId = userId ?? ""
        self.isMarkDeleted = false
    }


    
    func toDTO() -> ProjectDTO {
            ProjectDTO(
                id: self.id,
                name: self.name,
                userId: self.userId,
                lastModified: self.lastModified,
                items: self.itemsProject.map { $0.toDTO() }
            )
        }

}


