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
    var id: String // используется и в SwiftData, и в Firestore
    var name: String
    var userId: String
    var lastModified: Date
    var isSyncedWithCloud: Bool
    var dateAdd: Date
    @Relationship(deleteRule: .cascade) var itemsProject = [ItemProject]()
    var isActiv: Bool = false
    var isDeleted: Bool = false
    
    init(id: String = UUID().uuidString, name: String, userId: String? = "", itemsProject: [ItemProject] = [],  ) {
        self.id = id
        self.name = name
        self.itemsProject = itemsProject
        self.dateAdd = .now
        self.lastModified = .now
        self.isSyncedWithCloud = false
        self.userId = userId ?? ""
    }
    

    
//    func getCountByRM (_ reference: String) -> Int {
 //       return itemsProject.filter{$0.idProductRM == reference}.reduce(0) {$0 + $1.count}
 //   }
    

    
    func toDTO(userId: String) -> ProjectDTO {
            ProjectDTO(
                id: self.id,
                name: self.name,
                userId: userId,
                lastModified: self.lastModified,
                items: self.itemsProject.map { $0.toDTO() }
            )
        }
    

    
//    func incItem(item: ItemProject, count: Int = 1) {
//        let findedItem = itemsProject.first{$0.idProductRM == item.idProductRM &&
//            $0.price == item.price &&
//            $0.name == item.name}
//        guard  let findedItem = findedItem else {
//            itemsProject.append(item)
//            return
//        }
//        findedItem.count += 1
//    }
//    
//    
//    func decItem(item: ItemProject, count: Int = 1) {
//        if item.count > 1 {
//            item.count -= 1
//        } else {
//            if let index = itemsProject.firstIndex(where: { $0.idProductRM == item.idProductRM }) {
//                itemsProject.remove(at: index)
//            }
//        }
//    }
    
    
    func getItem(item: ItemProject) -> ItemProject{
        let findedItem = itemsProject.first{$0.idProductRM == item.idProductRM &&
            $0.price == item.price &&
            $0.name == item.name}
        guard  let findedItem = findedItem else {
            
            return item
        }
        return findedItem
        
         //   .filter{$0.idProductRM == reference}.reduce(0) {$0 + $1.count}
    }
}


