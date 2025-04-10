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
    var userFB = UserSettingsFireBaseViewModel.shared
    
    @Published var nameCategory = ""
    @Published var categories: [Category] = []
    
    func loadCategoryBy(id: Int) async {

        let featchedData = await PSServer.getDataCategoryBy(idCategory: id)
        
        do {
            if self.userFB.settings.contentLanguage != .ru {
                let categoryNames =  featchedData.categories.map { $0.name } + [featchedData.nameCategory]
                let targetLanguage = self.userFB.settings.contentLanguage.rawValue
                
                let translatedCategoryNames = try await fetchTranslation(
                    words: categoryNames,
                    targetLanguage: targetLanguage,
                    contentType: .word
                )

                
                guard categoryNames.count == translatedCategoryNames.count else {
                    print("Error: Number of translated names does not match the number of products")
                    return
                }
                
                for (index, _) in featchedData.categories.enumerated() {
                    featchedData.categories[index].name = translatedCategoryNames[index].trimmingCharacters(in: .whitespacesAndNewlines)
                }
                featchedData.nameCategory = translatedCategoryNames.last ?? ""
            }
            await MainActor.run {
                self.nameCategory = featchedData.nameCategory
                self.categories = featchedData.categories
                
            }
        } catch {
            print("Error receiving transfer: \(error)")
        }
        
        
    }
}

