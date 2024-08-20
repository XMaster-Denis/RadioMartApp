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
    
    @StateObject var settings = DataBase.shared.getSettings()
    
    var body: some View {
        VStack {
          
            
            ProjectPanelView()
            NavigationStack (path: $path.catalogPath) {
                
                CatalogAndProductsView(id: generalCategoryId)
                    .navigationBarTitleDisplayMode(.inline)
                
                    .navigationDestination(for: Product.self) { product in
                        ProductView(product: product)
                    }
                
                    .navigationDestination(for: Category.self) { category in
                        CatalogAndProductsView(id: category.id)
                        
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//#Preview {
//    CatalogNavigationView()
//}
