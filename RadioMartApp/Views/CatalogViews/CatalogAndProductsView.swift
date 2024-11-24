//
//  CatalogView.swift
//  RadioMartApp
//
//  Created by XMaster on 10.10.2023.
//

import SwiftUI

struct CatalogAndProductsView: View {
    var currentCategory: Int
    @State var isLoadingDone: Bool = false
  //  @State var test: String = "1"
    @StateObject var categoriesModel = CategoryModel()
    @StateObject var productsModel = ProductsModel()
    @StateObject var settings = DataBase.shared.getSettings()
 
    
    init(id: Int) {
        
        currentCategory = id
    }
    
    var body: some View {
        ZStack {
            List {
                if (categoriesModel.categories.count != 0) {
                    Section("caregories-string"){
                        ForEach(categoriesModel.categories){ category in
                            Button(action: {
                                Router.shared.catalogPath.append(category)
                            }, label: {
                                Label(category.name, systemImage: "cpu")

                            })
                        }
                        
                    }
                    
                }
                
                
                if (productsModel.products.count != 0) {
                    
                    Section("products-string"){
                        ForEach(productsModel.products){ product in
                            Button(action: {
                                Router.shared.catalogPath.append(product)
                            }, label: {
                                VStack{
                                    Text(product.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    HStack {
                                        VStack (alignment: .leading) {
                                            HStack {
                                                Text("reference:-string")
                                                Text(product.reference)
                                            }
                                            HStack {
                                                Text("price:-string \(product.priceDecimal.toLocateCurrencyString())")
                                            }
                                        }
                                        Spacer()
                                        ImageProductView(product.defaultImageUrl!)
                                            .scaledToFill()
                                            .frame(width: 160, height: 120)
                                            .clipShape(.rect(cornerRadius: 10))
                                            .padding(0)
                                    }
                                }
                                .overlay {
                                    ZStack {
                                        Button {
                                            let newItemProject = ItemProject(name: product.name, count: 1, price: product.priceDecimal, idProductRM: product.reference)
                                            settings.activProject.incItem(item: newItemProject)
                                        } label: {

                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.blue, lineWidth: 2)
                                                    .fill(Color.blue.opacity(0.8))
                                                    .frame(width: 36, height: 36)
                                                    .shadow(radius: 3, x: 3, y: 3)


                                                ZStack {
                                                    Image(systemName: "plus")

                                                        .imageScale(.large)
                                                        .fontWeight(.bold)

                                                }
                                                .foregroundStyle(Color.white)

                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                        .offset(x: 18, y:  -67)


                                        if let item = settings.activProject.getItemByRM(product.reference) {

                                            Button {
                                                settings.activProject.decItem(item: item)
                                            } label: {

                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.blue, lineWidth: 2)
                                                        .fill(Color.blue.opacity(0.8))
                                                        .frame(width: 36, height: 36)
                                                        .shadow(radius: 3, x: 3, y: 3)
                                                    ZStack {
                                                        Image(systemName: "minus")

                                                            .imageScale(.large)
                                                            .fontWeight(.bold)
                                                    }
                                                    .foregroundStyle(Color.white)

                                                }
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                            .offset(x: 18, y:  -10)

                                            RMBadgeView(item: item)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                                .offset(x: 12, y:  -20)
                                        }



                                    }



                                }
                            })
                        }
                    }
                    .navigationTitle(categoriesModel.nameCategory)
                  //  .navigationBarTitleDisplayMode(.inline)
                }
            }
            // .listStyle(.plain)
            
            
//            .refreshable {
//                await self.categoriesModel.loadCategoryBy(id: currentCategory)
//                productsModel.reload(idCategory: currentCategory)
//                isLoadingDone = true
//            }
            .task {
                
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await categoriesModel.loadCategoryBy(id: currentCategory)
                    }
                    group.addTask {
                        await productsModel.reload(idCategory: currentCategory)
                    }
                }
                isLoadingDone = true
            }
            
            if !isLoadingDone {
                ProgressView("loading-string")
            }
        }
    }
}

#Preview {
    CatalogAndProductsView(id: 47)
}
