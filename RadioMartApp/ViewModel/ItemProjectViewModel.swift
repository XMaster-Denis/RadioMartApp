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
    // Идентификатор можно получить из модели или генерировать здесь, если необходимо
    let id: UUID
    @ObservedObject var item: ItemProject

    // Для удобства можно добавить вычисляемые свойства, если они нужны для отображения
    var name: String {
        get { item.name }
        set {
            item.name = newValue
            objectWillChange.send()
            markModified()
        }
    }
    
    var count: Int {
        get { item.count }
        set {
            item.count = newValue
            objectWillChange.send()
            markModified()
        }
    }
    
    var price: Decimal {
        get { item.price }
        set {
            item.price = newValue
            objectWillChange.send()
            markModified()
        }
    }
    
    var idProductRM: String {
        get { item.idProductRM }
        set {
            item.idProductRM = newValue
            objectWillChange.send()
            markModified()
        }
    }
    
    init(item: ItemProject, insertIfNeeded: Bool = false) {
        self.item = item
        self.id = item.id
        if insertIfNeeded {
            print("insertIfNeeded")
            DataBase.shared.modelContext.insert(item)
            try? DataBase.shared.modelContext.save()
        }
    }
    
    private func markModified() {
        // Вызов сохранения или обновление чего-либо в базе.
        try? DataBase.shared.modelContext.save()
    }
}
