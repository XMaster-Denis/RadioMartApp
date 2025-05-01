//
//  SettingsDTO.swift
//  RadioMartApp
//
//  Created by XMaster on 27.04.25.
//

import Foundation

struct SettingsDTO: Codable, Identifiable  {
    var id: String
    var userId: String
    var activProjectId: String
    var languageCode: String
    var currentTab: Int
    var companyName: String
}

