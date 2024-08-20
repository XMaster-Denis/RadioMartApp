//
//  CustomerModel.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData

@Model
class Customer {
    var name: String
    var email: String
    var phone: String
    
    init(name: String, email: String, phone: String) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
