//
//  ProjectDTO.swift
//  RadioMartApp
//
//  Created by XMaster on 10.04.25.
//
import Foundation

struct ProjectDTO: Codable, Identifiable {
    var id: String
    var name: String
    var userId: String
    var lastModified: Date
    var items: [ItemProjectDTO]
}
