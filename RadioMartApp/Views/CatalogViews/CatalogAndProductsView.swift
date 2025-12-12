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
    @StateObject var categoriesModel = CategoryModel()
    @StateObject var productsModel = ProductsModel()
    @ObservedObject var localizationManager = LM.shared
//    @EnvironmentObject var settings: SettingsManager
//    @EnvironmentObject var activeProject: ProjectViewModel
    
    init(id: Int) {
        currentCategory = id
    }
    
    var body: some View {
        
        
        ZStack {
            
            if isLoadingDone {
                List {
                    if (categoriesModel.categories.count != 0) {
                        Section("caregories:string"){
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
                        
                        Section("products:string"){
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
                                                    Text("reference::string")
                                                    Text(product.reference)
                                                }
                                                HStack {
                                                    Text("price::string \(product.priceDecimal.toLocateCurrencyString())")
                                                }
                                            }
                                            Spacer()
                                            
                                            if let url = product.defaultImageUrl {
                                                ImageProductView(url)
                                                    .scaledToFill()
                                                    .frame(width: 160, height: 120)
                                                    .clipShape(.rect(cornerRadius: 10))
                                                    .padding(0)
                                            } else {
                                                ProgressView()
                                            }
                                            
//                                            ImageProductView(product.defaultImageUrl!)
//                                                .scaledToFill()
//                                                .frame(width: 160, height: 120)
//                                                .clipShape(.rect(cornerRadius: 10))
//                                                .padding(0)
                                        }
                                    }
                                    .overlay {
                                        ProductCounterView(product: product)
                                            .offset(x: 0, y:  0)
                                    }
                                })
                            }
                        }
//
                    }
                       
                }
                .listStyle(.plain)
                
            } else  {
                ProgressView("loading:string")
                    .task(id: localizationManager.currentLanguage) {
                        isLoadingDone = false
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask { await categoriesModel.loadCategoryBy(id: currentCategory) }
                            group.addTask { await productsModel.reload(idCategory: currentCategory) }
                        }
                        isLoadingDone = true
                    }
                
//                    .onAppear {
//                        isLoadingDone = false
//                        Task {
//                            await withTaskGroup(of: Void.self) { group in
//                                group.addTask {
//                                    await categoriesModel.loadCategoryBy(id: currentCategory)
//                                }
//                                group.addTask {
//                                    await productsModel.reload(idCategory: currentCategory)
//                                }
//                            }
//                            isLoadingDone = true
//                        }
//                    }
            }
        }
        .navigationTitle(categoriesModel.nameCategory)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: localizationManager.currentLanguage) {
            isLoadingDone = false
            Task{
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
        }
    }
}

#Preview {
    CatalogAndProductsView(id: 47)
}
