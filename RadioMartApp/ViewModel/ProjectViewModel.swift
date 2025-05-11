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
    let idU: UUID = UUID()
    let modelContext = DataBase.shared.modelContext
    let id: String
    @Published var project: Project
    @Published var itemsViewModel: [ItemProjectViewModel] = []
    
    
    
    init(_ project: Project, insertIfNeeded: Bool = false) {
        self.project = project
        self.itemsViewModel = project.itemsProject.map {
            ItemProjectViewModel(item: $0)
        }
        
        self.id = project.id
        if insertIfNeeded {
            print("insertIfNeeded Project")
            modelContext.insert(project)
            try? modelContext.save()
        }
    }
    
    
    var totalPrice: Decimal {
        project.itemsProject.reduce(0) { $0 + Decimal($1.count) * $1.price }
    }
    var totalItems: Int {
        project.itemsProject.count
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
    
    var userId: String {
        get { project.userId }
        set {
            project.userId = newValue
            markModified()
        }
    }
    
    var itemsProject: [ItemProject] {
        get { project.itemsProject.sorted{$0.dateAdd < $1.dateAdd} }
        set {
            project.itemsProject = newValue
            markModified()
        }
    }
    
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
            try? DataBase.shared.modelContext.save()
        }
    }
    var isMarkDeleted: Bool {
        get { project.isMarkDeleted }
        set {
            project.isMarkDeleted = newValue
            markModified()
        }
    }
    
    
    func updateName(_ newName: String) {
        project.name = newName
        markModified()
    }
    
    func markModified() {
        project.lastModified = .now
        project.isSyncedWithCloud = false
        try? DataBase.shared.modelContext.save()
    }
    
    func getItemByRM (_ reference: String) -> ItemProjectViewModel? {
        return itemsViewModel.first{$0.idProductRM == reference}
    }
    
    
    func incItem(item: Product, count: Int = 1) {
        
        
        if let findedItem = itemsViewModel.first(where: {$0.idProductRM == item.reference &&
            $0.price == item.priceDecimal &&
            $0.name == item.name}) {
            print("************incItem \(findedItem.id)")
            findedItem.count += 1
            markModified()
        } else {
            print("new")
            let newItem = ItemProject(name: item.name, count: count, price: item.priceDecimal, idProductRM: item.reference)
            project.itemsProject.append(newItem)
            let newItemProject = ItemProjectViewModel(item: newItem,  insertIfNeeded: true)
            itemsViewModel.append(newItemProject)
            markModified()
        }
    }
    
    
    
    
    
    func decItem(item: ItemProjectViewModel) {
        print("**************decItem \(item.id)")
        if item.count > 1 {
            item.count -= 1
        } else {
            if let index = itemsViewModel.firstIndex(where: { $0.idProductRM == item.idProductRM }) {
                itemsViewModel.remove(at: index)
                if let index = project.itemsProject.firstIndex(where: { $0.id == item.id }) {
                    let removedItem = project.itemsProject.remove(at: index)
                    modelContext.delete(removedItem)
                    
                }
                
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
}

nonisolated extension ProjectViewModel: Hashable {
    static func == (lhs: ProjectViewModel, rhs: ProjectViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
