//
//  ProjectLineView.swift
//  RadioMartApp
//
//  Created by XMaster on 18.12.2023.
//

import SwiftUI
import SwiftData

struct ProjectLineView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var body: some View {
        HStack {
            HStack {
                VStack {
                    Text(viewModel.project.name)
                    Text(viewModel.project.userId)
                        .font(.caption)
                    HStack {
                        Text("\(viewModel.project.isMarkDeleted)")
                            .font(.caption)
                        Text("\(viewModel.project.isSyncedWithCloud)")
                            .font(.caption)
                    }
                 
                    
                }
                
            }
                .foregroundStyle(.blue)
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer()
            VStack {
                HStack {
                    Text("itemscount:-string")
                    Text("\(viewModel.totalItems)")
                        .bold()
                }
                Text("\(viewModel.totalPrice.toLocateCurrencyString())")
                    .bold()
            }
            .padding(.trailing)
        }
        .contentShape(Rectangle())
    }
}

//
//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let schema = Schema([
//        Project.self,
//        ItemProject.self,
//        SettingsModel.self
//    ])
//    let container = try! ModelContainer(for: schema, configurations: config)
//    let context = container.mainContext
//    
//    
//    let IP1 = ItemProject(name: "Led", count: 2, price: 15.0, idProductRM: "10117")
//    let IP2 = ItemProject(name: "PCB", count: 1, price: 300.0, idProductRM: "14254")
//    let project = Project(name: "Test Project", itemsProject: [IP1, IP2])
//    context.insert(project)
//    
//    return ProjectLineView(viewModel: ProjectViewModel(project: project))
//        .modelContainer(container)
//
