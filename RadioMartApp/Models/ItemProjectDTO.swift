//
//  ItemProjectDTO.swift
//  RadioMartApp
//
//  Created by XMaster on 10.04.25.
//
import Foundation

struct ItemProjectDTO: Codable {
    var idProductRM: String
    var name: String
    var price: Decimal
    var count: Int
}
