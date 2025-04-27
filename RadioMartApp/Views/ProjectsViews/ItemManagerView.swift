//
//  ItemManagerView.swift
//  RadioMartApp
//
//  Created by XMaster on 03.01.2024.
//

import SwiftUI

struct ItemManagerView: View {
    
    @StateObject var itemVM: ItemViewModel
    @Binding var isEditingItem: Bool
    @State var title: String = ""
    @State var name: String = ""
    @State var count: String = ""
    @State var price: String = ""
    
    let updateProject: () -> Void
    
 
    
    var body: some View {
     //   ZStack {
            GeometryReader { proxy in
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.white)
                        .shadow(radius: 10)
                      //  .frame(width: proxy.size.width - 10, height: proxy.size.height - 10, alignment: .center)
                    VStack (spacing: 3){
                        Text(title)
                            
                        
                        Divider()
                            .padding(.bottom, 10)
                        
                        ValidationForm { valid in
                            
                            Text("productname-string")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.gray)
                            IconTextField("productname-string", text: $name) {
                                $0.textFieldStyle(.roundedBorder)
                            } modIcon: { $0
                            } condition: {
                                !name.isEmpty
                            }
                            
                            Text("productcount-string")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.gray)
                            IconTextField("productcount-string", text: $count) {
                                $0.textFieldStyle(.roundedBorder)
                            } modIcon: { $0
                            } condition: {
                                let result = Int(count) ?? 0
                                return result >= 0 ? true : false
                            }
                            
                            Text("productprice-string")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.gray)
                            IconTextField("productprice-string", text: $price) {
                                $0.textFieldStyle(.roundedBorder)
                            } modIcon: { $0
                            } condition: {
                                let result = Decimal(string: price) ?? 0
                                return result >= 0 ? true : false
                            }
                            
                            Button("saveitem-string") {
                                itemVM.price = Decimal(string: price) ?? 0
                                itemVM.count = Int(count) ?? 0
                                itemVM.name = name
                                updateProject()
                                isEditingItem.toggle()
                            }
                            .buttonStyle(.bordered)
                            .disabled(!valid)
                        }
                        Spacer()
                        
                    }
                    .padding()
                }
                .onAppear() {
                    title = itemVM.item.name
                    count = String(itemVM.item.count)
                    name = itemVM.item.name
                    price = "\(itemVM.item.price)"
                }
               
                .frame(width: proxy.size.width * 0.95, height: proxy.size.height * 0.98, alignment: .center)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .overlay {
                    
                    Button(action: {
                        withAnimation(.linear(duration: 0.2)) {
                            isEditingItem.toggle()
                        }
                    }, label: {
                        
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                
                                .frame(width: 50, height: 50, alignment: .center)
                            
                            Image(systemName: "xmark.circle")
                                .font(.largeTitle)
                                .offset(x: 1)
                        }
                        .padding(.trailing, 10)
                        
                        
                    })
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .shadow(radius: 5)
                }
                
                
            }
            .zIndex(5)
    }
}
