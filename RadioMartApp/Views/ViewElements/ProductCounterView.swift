//
//  ProductCounter.swift
//  RadioMartApp
//
//  Created by XMaster on 10.05.25.
//

import SwiftUI

struct ProductCounterView: View {
    @EnvironmentObject var settings: SettingsManager
    var product: Product
    var body: some View {
        ZStack {
            Button {
                settings.currentProjectViewModel.incItem(item: product)
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

            if  let item: ItemProjectViewModel = settings.currentProjectViewModel.getItemByRM(product.reference) {
                
                Button {
                    settings.currentProjectViewModel.decItem(item: item)
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
                //                                                    .task {
                //                                                        print(item.count)
                //                                                    }
            }
            
            
            
        }
    }
}

//#Preview {
//    ProductCounterView()
//}
