//
//  ItemProject.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData

@Model
class ItemProject: ObservableObject, Identifiable {
    var id = UUID()
    var dateAdd: Date = Date.now
    var name: String
    var count: Int
    var price: Decimal
    var idProductRM: String
    var urls: [URL] = []
    var discription: String = ""
    var sumItem: Decimal {
        price * Decimal(count)
    }
  //  var project: Project
    
    init(name: String, count: Int, price: Decimal, idProductRM: String = ""/*, project: Project*/) {
        self.name = name
        self.count = count
        self.price = price
        self.idProductRM = idProductRM
        //self.project = project
    }
    
    func toDTO() -> ItemProjectDTO {
        ItemProjectDTO(
            idProductRM: self.idProductRM,
            name: self.name,
            price: self.price,
            count: self.count
        )
    }
}
