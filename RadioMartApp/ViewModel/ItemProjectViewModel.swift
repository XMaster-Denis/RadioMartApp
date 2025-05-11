//
//  ItemViewModel.swift
//  RadioMartApp
//
//  Created by XMaster on 13.04.25.
//


import Foundation
import SwiftUI

@MainActor
class ItemProjectViewModel: ObservableObject, Identifiable {
    
    let id: UUID
    @ObservedObject var item: ItemProject
    
    var name: String {
        get { item.name }
        set {
            item.name = newValue
            markModified()
        }
    }
    
    var count: Int {
        get { item.count }
        set {
            item.count = newValue
            markModified()
        }
    }
    
    var price: Decimal {
        get { item.price }
        set {
            item.price = newValue
            markModified()
        }
    }
    
    var idProductRM: String {
        get { item.idProductRM }
        set {
            item.idProductRM = newValue
            markModified()
        }
    }
    
    init(item: ItemProject, insertIfNeeded: Bool = false) {
        self.item = item
        self.id = item.id
        if insertIfNeeded {
            print("insertIfNeeded ItemProject")
            DataBase.shared.modelContext.insert(item)
            try? DataBase.shared.modelContext.save()
        }
    }
    
    private func markModified() {
        try? DataBase.shared.modelContext.save()
    }
}
