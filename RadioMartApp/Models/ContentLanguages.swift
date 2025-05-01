//
//  ContentLanguages.swift
//  RadioMartApp
//
//  Created by XMaster on 27.04.25.
//



enum ContentLanguages: String, CaseIterable, Identifiable, Codable {
    case de = "German"
    case en = "English"
    case ru = "Russian"
    
    var id: Self { self }
    var code: String {"\(self)"}
}