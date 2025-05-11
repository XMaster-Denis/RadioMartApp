//
//  ProductView.swift
//  RadioMartApp
//
//  Created by XMaster on 02.10.2023.
//

import SwiftUI
import RichText



struct ProductView: View {
    var product: Product
    @State var productImagesURL: [URL] = []
    @State var selectedImage: String = ""
    @State var zoomedImage: String = ""
    @State private var anchorZoom: UnitPoint = .center
    @State private var descriptionAllRichText: String = ""
    @State private var nameProduct: String = ""
    @State var isDescriptionReceived: Bool = false
    @ObservedObject var localizationManager = LM.shared

    
    init(product: Product) {
        self.product = product
        print("ProductView")
    }
    
    var body: some View {
        GeometryReader { geometryScreen in
            let screenSize = geometryScreen.size
            ScrollView(.vertical) {
                Text(product.name)
                TabView(selection: $selectedImage) {
                    ForEach(productImagesURL, id: \.absoluteString){ productURL in
                        GeometryReader { imageGeometry in
                            let imageSize = imageGeometry.size
                            ZoomImage(isZoom: zoomedImage == productURL.absoluteString, anchorZoom: anchorZoom) {
                                ImageProductView(productURL)
                                    .frame(width: imageSize.width)
                                    .tag(productURL.absoluteString)
                                    .onTapGesture(count: 2, perform: { value in
                                        if zoomedImage != productURL.absoluteString {
                                            anchorZoom = UnitPoint(x: value.x/imageSize.width, y: value.y/imageSize.height)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                                withAnimation(.linear(duration: 0.5)) {
                                                    zoomedImage = productURL.absoluteString
                                                }
                                            }
                                        } else {
                                            zoomedImage = ""
                                        }
                                    })
                                
                            }
                        }
                    }
                }
                .overlay {
                    ProductCounterView(product: product)
                        .offset(x: -25, y:  -100)
                }
                
                .tabViewStyle(PageTabViewStyle())
                .frame(width: screenSize.width, height: screenSize.width * 0.75)
                .onChange(of: selectedImage, initial: true) {
                    zoomedImage = ""
                }
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(productImagesURL, id: \.self){ productURL in
                            PreviewImage(isSelected: selectedImage == productURL.absoluteString){
                                ImageProductView(productURL)
                                    .onTapGesture {
                                        selectedImage = productURL.absoluteString
                                    }
                            }
                            .frame(height: 50)
                        }
                    }
                    .frame(height: 55)
                }
                .task {
                    productImagesURL = await PSServer.getImagesURLBy(idProduct: product.id)
                    selectedImage = productImagesURL.first?.absoluteString ?? ""
                }
                .scrollIndicators(.hidden)
                if isDescriptionReceived {
                    
                    RichText(html: descriptionAllRichText)
                        .padding(.horizontal)
                        
                } else {
                    
                      ProgressView("loading-string")
                          .task {
                              
                              if LM.shared.currentLanguage != .ru {
                                  do {
                                      let translatedText = try await fetchTranslation(
                                        words: [product.descriptionAllRichText],
                                        targetLanguage: LM.shared.currentLanguage.rawValue,
                                        contentType: .html
                                      ).first ?? product.descriptionAllRichText
                                      
                                      await MainActor.run {
                                          descriptionAllRichText = translatedText
                                      }
                                  } catch {
                                      print("Translation error: \(error)")
                                  }
                              } else {
                                  descriptionAllRichText = product.descriptionAllRichText
                              }
                              
                              isDescriptionReceived = true

                              
                          }
                  
                }
                    
            }
        }
        .onChange(of: localizationManager.currentLanguage) {
            isDescriptionReceived = false
        }
    }
    
}

struct PreviewImage<Content: View>: View {
    
    private let cornerRadius: CGFloat
    private let width: CGFloat
    private let isSelected: Bool
    private let content: () -> Content
    
    init(isSelected: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isSelected = isSelected
        self.content = content
        self.cornerRadius = isSelected ? 20.0 : 3.0
        self.width = isSelected ? 60.0 : 5.0
    }
    
    var body: some View {
        content()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay (alignment: .bottom) {
                HStack {
                    Rectangle()
                        .foregroundStyle(.blue)
                        .frame(width: width, height: 2)
                }
            }
            .animation(.spring(response: 0.9, dampingFraction: 0.5, blendDuration: 1.0), value: width)
    }
}

struct ZoomImage<Content: View>: View {
    
    private let totalZoom: CGFloat
    private let anchorZoom: UnitPoint
    private let content: () -> Content
    
    init(isZoom: Bool, anchorZoom: UnitPoint,  @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.totalZoom = isZoom ? 3.0 : 1.0
        self.anchorZoom = anchorZoom
    }
    
    var body: some View {
        content()
            .scaleEffect(totalZoom, anchor: anchorZoom)
            .animation(.linear(duration: 0.2), value: totalZoom)
    }
}


#Preview {
    ProductView(product: Product(id: 1234, id_default_image: "19919", reference: "12478", price: "125", description: "Карта памяти — компактное электронное запоминающее устройство, используемое для хранения цифровой информации. Современные карты памяти изготавливаются на основе флеш-памяти, хотя принципиально могут использоваться и другие технологии. Комплект поставки и внешний вид данного товара могут отличаться от указанных на фотографиях в каталоге интернет-магазина.", description_short: "description_short description_short description_short description_short description_short", name: "Передатчик 333") )
    
}
