//
//  Network.swift
//  RadioMartApp
//
//  Created by XMaster on 23.09.2023.
//

import Foundation
import Alamofire
import SWXMLHash
import Kingfisher

class PSServer {
    
    enum Field: String {
        case forCatalog = "[id,name,id_default_image,reference,price,description,description_short]"
    }
    
    private static let privateAPIKey = "C2BXEBEZHNA28ZJ4QKRPISUZT98975HK"
    private static let passwordAPIKey = ""
    private static let baseURL = "https://radiomart.kz/"
    private static let baseURLAPI = baseURL+"api/"
    
    
    
    static let shared = PSServer()
    
    static let requestModifier = AnyModifier { request in
        let loginString = String(format: "%@:%@", privateAPIKey, passwordAPIKey)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        var r = request
        r.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        return r
    }
    
    
    
    private init (){}
    
    static func getBaseURL() -> String {baseURL}
    
    static func getProductsBy(idCategory:Int, fields: Field) async -> ProductsModel {
        let result = ProductsModel()
        do {
            
            let response = try await AF.request(baseURLAPI + "products/?display=" + fields.rawValue + "&output_format=JSON&filter[id_category_default]=\(idCategory)")
                .authenticate(username: privateAPIKey, password: passwordAPIKey)
                .serializingData().value
            
            if response.count == 2 {
                return result
            }
            
            
            var prod: ProductsJSON = ProductsJSON(products: [])
            do {
                prod = try JSONDecoder().decode(ProductsJSON.self, from: response)
            } catch {
                print("Error in getProductsBy2 \(error)")
            }
            result.products = prod.products
            
        } catch {
            print("Error in getProductsBy1 \(error)")
            
        }
        return result
    }
    
    // https://radiomart.kz/api/images/products/1057/19919
    static func getImageUrlFrom (idProduct: Int, id_default_image: String) -> URL? {
        return URL(string: baseURLAPI+"images/products/\(idProduct)/\(id_default_image)/home_default")
    }
    
    
    // https://radiomart.kz/api/images/products/\(idProduct)?output_format=JSON
    static func getImagesURLBy(idProduct:Int) async -> [URL] {
        var result: [URL] = []
        do {
            let data = try await AF.request(baseURLAPI + "images/products/\(idProduct)")
                .authenticate(username: privateAPIKey, password: passwordAPIKey)
                .serializingData().value
            let xml = XMLHash.parse(data)
            for elem in xml["prestashop"]["image"]["declination"].all {
                guard let stringURL = elem.element?.attribute(by: "xlink:href")?.text,
                      let url = URL(string: stringURL + "/thickbox_default")  else {continue}
                result.append(url)
            }
        } catch {
            
        }
        return result
    }
    
    
    // https://radiomart.kz/api/images/products/\(idProduct)?output_format=JSON
    static func getImagesURLBy2(idProduct:Int) async -> [URL] {
        var result: [URL] = []
        do {
            let data = try await AF.request(baseURLAPI + "images/products/\(idProduct)")
                .authenticate(username: privateAPIKey, password: passwordAPIKey)
                .serializingData().value
            let xml = XMLHash.parse(data)
            for elem in xml["prestashop"]["image"]["declination"].all {
                guard let stringURL = elem.element?.attribute(by: "xlink:href")?.text,
                      let url = URL(string: stringURL )  else {continue}
                result.append(url)
            }
        } catch {
            
        }
        return result
    }
    
    
    static func getDataCategoryBy(idCategory:Int) async -> CategoryModel {
        
        let result: CategoryModel = CategoryModel()
        result.nameCategory = ""
        do {
            let dataID = try await AF.request(baseURLAPI + "categories/?display=[name,categories[id]]&filter[id]=[\(idCategory)]")
                .authenticate(username: privateAPIKey, password: passwordAPIKey)
                .serializingData().value
            
            let xmlId = XMLHash.parse(dataID)
            guard let nameRootCategory = xmlId["prestashop"]["categories"]["category"]["name"]["language"].element?.text else {return result}
            result.nameCategory = nameRootCategory
            var categoriesIDs: [String] = []
            for elementCategory in xmlId["prestashop"]["categories"]["category"]["associations"]["categories"]["category"].all {
                guard let idCategory = elementCategory["id"].element?.text
                else {continue}
                categoriesIDs.append(idCategory)
            }
            
            let stringWithCategories: String = categoriesIDs.reduce("") {
                $0.count == 0 ? $0 + $1 : $0 + "|" + $1
            }
            
            
            let dataName = try await AF.request(baseURLAPI + "categories/?display=[id,name]&filter[id]=[\(stringWithCategories)]")
                .authenticate(username: privateAPIKey, password: passwordAPIKey)
                .serializingData().value
            
            let xmlName = XMLHash.parse(dataName)
            
            for elementNamedCategory in xmlName["prestashop"]["categories"]["category"].all {
                guard let idCategoryStr = elementNamedCategory["id"].element?.text,
                      let idCategory = Int(idCategoryStr),
                      let nameCategory = elementNamedCategory["name"]["language"].element?.text
                else {return result}
                result.categories.append(Category(id: idCategory, name: nameCategory))
            }
        } catch AFError.explicitlyCancelled {
            
        } catch {
            print(error)
        }
        return result
    }
}


