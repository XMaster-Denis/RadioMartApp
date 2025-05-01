//
//  ProjectViewModel.swift
//  RadioMartApp
//
//  Created by XMaster on 11.04.25.
//


import Foundation
import SwiftUI

@MainActor
class ProjectViewModel: ObservableObject {
    @Published var project: Project
    var totalPrice: Decimal {
        project.itemsProject.reduce(0) { $0 + Decimal($1.count) * $1.price }
    }
    var totalItems: Int {
        project.itemsProject.count
    }
    @Published var itemsViewModel: [ItemViewModel] = []
    
    init(project: Project) {
        self.project = project
        updateItemsViewModel()
    }
    
    
    var isEmpty: Bool {
        project.itemsProject.isEmpty
    }


    var name: String {
        get { project.name }
        set {
            project.name = newValue
            markModified()
        }
    }
    
    var items: [ItemProject] {
        get { project.itemsProject.sorted{$0.dateAdd < $1.dateAdd} }
        set {
            project.itemsProject = newValue
            markModified()
        }
    }
    
    // Если в модели есть другие поля, например:
    var lastModified: Date {
        get { project.lastModified }
        set {
            project.lastModified = newValue
            markModified()
        }
    }
    
    var isSyncedWithCloud: Bool {
        get { project.isSyncedWithCloud }
        set {
            project.isSyncedWithCloud = newValue
            markModified()
        }
    }
    

    
    private func updateItemsViewModel() {
        itemsViewModel = project.itemsProject.map { ItemViewModel(item: $0) }
    }

    
    


    func updateName(_ newName: String) {
        project.name = newName
        markModified()
    }
    
    func markModified() {
        try? DataBase.shared.modelContext.save()
        project.lastModified = .now
        project.isSyncedWithCloud = false
        try? DataBase.shared.modelContext.save()
        updateItemsViewModel()
    }
    
    func getItemByRM (_ reference: String) -> ItemProject? {
        return project.itemsProject.first{$0.idProductRM == reference}
    }
    
    
    func incItem(item: ItemProject, count: Int = 1) {
        let findedItem = project.itemsProject.first{$0.idProductRM == item.idProductRM &&
            $0.price == item.price &&
            $0.name == item.name}
        guard  let findedItem = findedItem else {
            project.itemsProject.append(item)
            markModified()
            return
        }
        findedItem.count += 1
        markModified()
    }
    
    
    

    
    func decItem(item: ItemProject) {
        if item.count > 1 {
            item.count -= 1
        } else {
            if let index = project.itemsProject.firstIndex(where: { $0.idProductRM == item.idProductRM }) {
                project.itemsProject.remove(at: index)
            }
        }
        markModified()
    }
    
    private func getProductsPrice() -> Decimal {
        var summa: Decimal = 0
        for item in project.itemsProject {
                    summa += Decimal(item.count) * item.price
                }
        return summa
    }

//    func addItem(_ item: ItemProject) {
//        project.itemsProject.append(item)
//        project.markModified()
//    }
//
//    func removeItem(_ item: ItemProject) {
//        if let index = project.itemsProject.firstIndex(where: { $0.idProductRM == item.idProductRM }) {
//            project.itemsProject.remove(at: index)
//            project.markModified()
//        }
//    }
//
//    func increaseItem(_ item: ItemProject) {
//        if let target = project.itemsProject.first(where: { $0.idProductRM == item.idProductRM }) {
//            target.count += 1
//            project.markModified()
//        }
//    }
//
//    func decreaseItem(_ item: ItemProject) {
//        if let target = project.itemsProject.first(where: { $0.idProductRM == item.idProductRM }) {
//            if target.count > 1 {
//                target.count -= 1
//            } else {
//                removeItem(item)
//                return
//            }
//            project.markModified()
//        }
//    }
}
