//
//  CategoryModel.swift
//  RadioMartApp
//
//  Created by XMaster on 03.10.2023.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    var id: Int
    var name: String
}


class CategoryModel: ObservableObject {
    var nameCategory = ""
    @Published var categories: [Category] = []
    func loadCategoryBy(id: Int) async {
        let featchedData = await PSServer.getDataCategoryBy(idCategory: id)
        await MainActor.run {
            self.categories = featchedData.categories
            self.nameCategory = featchedData.nameCategory
        }
    }
}

