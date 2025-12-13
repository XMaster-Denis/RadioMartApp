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
    
    init(id: Int) {
        currentCategory = id
    }

    @MainActor
    private func reloadData() async {
        isLoadingDone = false
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await categoriesModel.loadCategoryBy(id: currentCategory) }
            group.addTask { await productsModel.reload(idCategory: currentCategory) }
        }
        isLoadingDone = true
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
                                        }
                                    }
                                    .overlay {
                                        ProductCounterView(product: product)
                                            .offset(x: 0, y:  0)
                                    }
                                })
                            }
                        }
                    }
                       
                }
                .listStyle(.plain)
                
            } else  {
                ProgressView("loading:string")
                    .task(id: localizationManager.currentLanguage) {
                        await reloadData()
                    }
            }
            if categoriesModel.categories.isEmpty && productsModel.products.isEmpty && isLoadingDone {
                VStack(spacing: 12) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)

                    Text("products.not.loaded:string")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Button {
                        Task { await reloadData() }
                    } label: {
                        Label("reload:string", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .padding()
            }
        }
        .navigationTitle(categoriesModel.nameCategory)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: localizationManager.currentLanguage) {
            Task { await reloadData() }
        }
    }
}

#Preview {
    CatalogAndProductsView(id: 47)
}
