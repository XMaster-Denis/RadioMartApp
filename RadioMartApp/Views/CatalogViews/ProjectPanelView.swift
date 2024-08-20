//
//  ProjectPanelView.swift
//  RadioMartApp
//
//  Created by XMaster on 18.12.2023.
//

import SwiftUI
import SwiftData

struct ProjectPanelView: View {
    @Query var projects: [Project]
    @StateObject var settings = DataBase.shared.getSettings()
    
    var body: some View {
        HStack {
            Text("currentproject:-string")
                .lineLimit(1)
                .fixedSize()
            Spacer()
            VStack (spacing:0) {
                Picker("currentproject:-string", selection: $settings.activProject) {
                    ForEach(projects) { project in
                        
                        Text("\(project.name)")
                            .tag(project)
                            .fixedSize()
                        
                    }
                }
                    .fixedSize()
                Text("\(settings.activProject.getProductsPrice().toLocateCurrencyString())")
                    .monospacedDigit()
            }
            
            
            
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    ProjectPanelView()
//}
