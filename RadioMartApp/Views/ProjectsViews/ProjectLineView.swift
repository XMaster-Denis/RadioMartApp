//
//  ProjectLineView.swift
//  RadioMartApp
//
//  Created by XMaster on 18.12.2023.
//

import SwiftUI
import SwiftData

struct ProjectLineView: View {
    @ObservedObject var project: Project
    var body: some View {
        HStack {
            HStack {
//                Image(systemName: "cpu")
//                    .font(.callout)
            Text(project.name)
            }
                .foregroundStyle(.blue)
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer()
            VStack {
             //   Text("totalsum:-string")
                HStack {
                    Text("itemscount:-string")
                    Text("\(project.itemsProject.count)")
                        .bold()
                }
                Text("\(project.getProductsPrice().toLocateCurrencyString())")
                    .bold()
            }
            .padding(.trailing)
        }
        .contentShape(Rectangle())
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema([
        Project.self,
        ItemProject.self,
        Settings.self
    ])
    let container = try! ModelContainer(for: schema, configurations: config)
    let context = container.mainContext
    
    
    let IP1 = ItemProject(name: "Led", count: 2, price: 15.0, idProductRM: "10117")
    let IP2 = ItemProject(name: "PCB", count: 1, price: 300.0, idProductRM: "14254")
    let project = Project(name: "Test Project", itemsProject: [IP1, IP2])
    context.insert(project)
    
    return ProjectLineView(project: project)
        .modelContainer(container)
}
