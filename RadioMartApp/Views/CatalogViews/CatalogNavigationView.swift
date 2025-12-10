//
//  CatalogView.swift
//  RadioMartApp
//
//  Created by XMaster on 23.09.2023.
//

import SwiftUI
import SwiftData

struct CatalogNavigationView: View {
    let generalCategoryId = 2
    @ObservedObject var path = Router.shared
//    @State private var searchText: String = ""
       
    var body: some View {
        VStack (spacing: 0) {
          
            
            ProjectPanelView()
            NavigationStack (path: $path.catalogPath) {
                
                CatalogAndProductsView(id: generalCategoryId)
//                    .navigationBarTitleDisplayMode(.inline)
                
                    .navigationDestination(for: Product.self) { product in
                        ProductView(product: product)
                    }
                
                    .navigationDestination(for: Category.self) { category in
                        CatalogAndProductsView(id: category.id)
                        
                    }
                    .navigationTitle("root_catalog_name:string")
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
