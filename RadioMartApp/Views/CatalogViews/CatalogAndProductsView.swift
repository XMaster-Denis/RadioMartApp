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
    @State var test: String = "1"
    @StateObject var categoriesModel = CategoryModel()
    @StateObject var productsModel = ProductsModel()
    @StateObject var settings = DataBase.shared.getSettings()
    init(id: Int) {
        
        currentCategory = id
    }
    
//    // Функция для загрузки и сохранения изображений в папку "Images3"
//       func downloadAndSaveImages(from urls: [URL]) async {
//           let imagesFolder = getImagesDirectory()
//
//           for url in urls {
//               do {
//                   // Загружаем данные по URL
//                   let (data, _) = try await URLSession.shared.data(from: url)
//
//                   // Определяем имя файла (последний компонент URL + .jpg)
//                   let filename = url.deletingPathExtension().lastPathComponent + ".jpg"
//                   let fileURL = imagesFolder.appendingPathComponent(filename)
//
//                   // Сохраняем файл в папку Images3
//                   try data.write(to: fileURL)
//
//                   print("Изображение сохранено: \(fileURL)")
//               } catch {
//                   print("Ошибка при загрузке или сохранении изображения: \(error)")
//               }
//           }
//       }
    
    // Функция для параллельной загрузки изображений и их сохранения
//     func downloadImagesConcurrently() async {
//         let imagesFolder = getImagesDirectory()
//
//         await withTaskGroup(of: Void.self) { group in
//             for product in productsModel.products {
//                 group.addTask {
//                     let imageURLs = await PSServer.getImagesURLBy2(idProduct: product.id)
//
//                     for url in imageURLs {
//                         do {
//                             let (data, _) = try await URLSession.shared.data(from: url)
//                             let filename = url.deletingPathExtension().lastPathComponent + ".jpg"
//                             let fileURL = imagesFolder.appendingPathComponent(filename)
//
//                             try data.write(to: fileURL)
//                             print("Изображение сохранено: \(fileURL)")
//                         } catch {
//                             print("Ошибка при загрузке или сохранении изображения: \(error)")
//                         }
//                     }
//                 }
//             }
//         }
//     }

       // Функция для получения пути к папке "Images3" и создания ее, если она не существует
//       func getImagesDirectory() -> URL {
//           let fileManager = FileManager.default
//           let appDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//           let imagesFolder = appDirectory.appendingPathComponent("Images3")
//
//           // Проверяем, существует ли папка, если нет — создаем
//           if !fileManager.fileExists(atPath: imagesFolder.path) {
//               do {
//                   try fileManager.createDirectory(at: imagesFolder, withIntermediateDirectories: true, attributes: nil)
//                   print("Папка Images3 создана по пути: \(imagesFolder.path)")
//               } catch {
//                   print("Не удалось создать папку Images3: \(error)")
//               }
//           }
//
//           return imagesFolder
//       }
    
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
//                        Button("Download Images") {
//                            Task {
//                                await downloadImagesConcurrently()
////                                // Создаем пустой массив для хранения всех URL
////                                var allProductImagesURL: [URL] = []
////                                
////                                // Используем TaskGroup для параллельного выполнения задач
////                                await withTaskGroup(of: [URL].self) { group in
////                                    for product in productsModel.products {
////                                        // Добавляем задачу в группу для каждого продукта
////                                        group.addTask {
////                                            let productImagesURL = await PSServer.getImagesURLBy2(idProduct: product.id)
////                                            return productImagesURL
////                                        }
////                                    }
////                                    
////                                    // Суммируем результаты всех задач
////                                    for await imagesURL in group {
////                                        allProductImagesURL.append(contentsOf: imagesURL)
////                                    }
////                                }
////                                
////                                // Теперь у вас есть все URL-адреса изображений
////                                print("Все URL изображений: \(allProductImagesURL)")
////                                // Скачиваем изображения и сохраняем их на телефон
////                                await downloadAndSaveImages(from: allProductImagesURL)
//                            }
//                            
//                        }
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
                                            // print("\(settings.activProject.getCountByRM(product.reference))")
                                            // test = "\(Int.random(in: 1...10))"
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
                                                    // if let item = settings.activProject.getItemByRM(product.reference) {
                                                    //     RMBadgeView(item: item)
                                                    // }

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
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            // .listStyle(.plain)
            
            
            .refreshable {
                await self.categoriesModel.loadCategoryBy(id: currentCategory)
                productsModel.reload(idCategory: currentCategory)
                isLoadingDone = true
            }
            .task {
                await self.categoriesModel.loadCategoryBy(id: currentCategory)
                productsModel.reload(idCategory: currentCategory)
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
