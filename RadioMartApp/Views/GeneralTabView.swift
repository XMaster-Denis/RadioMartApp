//
//  GeneralTabView.swift
//  RadioMartApp
//
//  Created by XMaster on 23.09.2023.
//

import SwiftUI
import SwiftData

struct GeneralTabView: View {
    @StateObject var settings = DataBase.shared.getSettings()
    
   // @State var currentTab: Int = 0
    
    var body: some View {
        
        VStack {
           

            
          //  var activProject2 = settings.activProject
            
            
            //@Bindable var result2 = result.first!
            
           
            //result.first?.language
            
         //   Text(result.first?.language ?? "111")
            TabView (selection: $settings.currentTab) {
                CatalogNavigationView()
                    .tabItem {
                        Label("catalog-string", systemImage: "square.grid.3x3.topleft.filled")
                    }
                    .tag(0)
                
                ProjectsView()
                    .tabItem {
                        Label("projects-string", systemImage: "bag")
                    }
                    .tag(1)
                
                AICameraView()
                    .tabItem {
                    Label("aicamera-string", systemImage: "sparkle.magnifyingglass")
                }
                    .tag(2)
                
                AccountView()
                    .tabItem {
                        Label("account-string", systemImage: "person")
                    }
                    .tag(3)
            }
        }
    }
}

#Preview {
    GeneralTabView()
        .environment(\.locale, Locale(identifier: "en"))
}

#Preview {
    GeneralTabView()
        .environment(\.locale, Locale(identifier: "ru"))
}

