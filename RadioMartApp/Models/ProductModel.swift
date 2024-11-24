//
//  ProductModel.swift
//  RadioMartApp
//
//  Created by XMaster on 23.09.2023.
//

import SwiftUI
import Alamofire



// MARK: - ProductElement
struct Product: Codable, Identifiable, Hashable {
    var id: Int
    var id_default_image: String
    var reference: String
    var price: String
    var description: String
    
    var descriptionRichText: String {
        getRichTextFrom (description, withBaseURL: PSServer.getBaseURL())
    }
    var descriptionAllRichText: String {
        getRichTextFrom (description_short + description, withBaseURL: PSServer.getBaseURL())
    }
    var description_short: String
    var description_shortRichText: String {
        getRichTextFrom (description_short, withBaseURL: PSServer.getBaseURL())
    }
    var name: String
    var defaultImageUrl: URL? {
        PSServer.getImageUrlFrom(idProduct: id, id_default_image: id_default_image)
    }
    var priceDecimal: Decimal {
        Decimal(string: price) ?? 0
    }
    
    private func getRichTextFrom (_ rawString: String, withBaseURL baseURL: String) -> String {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let addedHTML = rawString.replacingOccurrences(of: "src=\"/", with: "src=\"\(baseURL)")
        let htmlString = "\(htmlStart)\(addedHTML)\(htmlEnd)"
        
        return htmlString
    }
}

struct ProductsJSON: Codable {
    var products: [Product]
}

class ProductsModel: ObservableObject {
    var userFB = UserSettingsFireBaseViewModel.shared
    @Published var products: [Product] = []
    
    func reload(idCategory: Int) async {
        
        
        
                let productsReturn = await PSServer.getProductsBy(idCategory: idCategory, fields: .forCatalog)
        
                do {
                    if self.userFB.settings.contentLanguage != .RU {
        
                        //var productNames = TranslationJSONData()
                    
                        
                        let productNames = productsReturn.products.map { $0.name }
                        let targetLanguage = self.userFB.settings.contentLanguage.rawValue

                        let translatedName = try await fetchTranslation(
                            words: productNames,
                            targetLanguage: targetLanguage,
                            contentType: .word
                        )
                        
                       
                        
                        // Убедимся, что количество элементов совпадает
                        guard productsReturn.products.count == translatedName.count else {
                            print("Error: Number of translated names does not match the number of products")
                            return
                        }


                        for (index, translated) in translatedName.enumerated() {
                            productsReturn.products[index].name = translated
                        }
                       
                    }
                    await MainActor.run {
    
                        self.products = productsReturn.products
    
                    }
                } catch {
                    print("Error receiving transfer: \(error)")
                }
        
        
    }
}
