//
//  ItemRowDetailView.swift
//  RadioMartApp
//
//  Created by XMaster on 30.12.2023.
//

import SwiftUI
import SwiftData

struct ItemRowDetailForIPhoneView: View {
    @ObservedObject var project: ProjectViewModel
    @StateObject var item: ItemProject
    var body: some View {
        HStack (spacing: 1) {
            Button(action: {
                withAnimation(.linear(duration: 0.4)) {
                    project.project.itemsProject.removeAll(where: { $0.id == item.id })
                }
            }) {
                Image(systemName: "xmark.circle")
                    .bold()
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .background {
                        Circle()
                            .foregroundStyle(.white)
                    }
            }
            Text(String(item.name ))
                .multilineTextAlignment(.leading)
                .bold()
                .font(.caption)
            
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 3) {
                    Text(String(item.count))
                    Text("X")
                    Text(String(item.price.toLocateCurrencyString() ))
                    Text("=")
                    Text(String(item.sumItem.toLocateCurrencyString() ))
                }
                .font(.caption)
                if !item.idProductRM.isEmpty {
                    HStack (spacing: 3) {
                        Text("ref:-string")
                        Text(item.idProductRM)
                            .monospaced()
                    }
                    .font(.caption)
                }
            }
            
        }
        .contentShape(Rectangle())
        
        
    }
}

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
//    let IP1 = ItemProject(name: "Led Electron PCB component Led Electron component ", count: 2, price: 15.0, idProductRM: "10117")
//    let IP2 = ItemProject(name: "PCB", count: 1, price: 300.0, idProductRM: "14254")
//    let IP3 = ItemProject(name: "Capasitor 220 uf 12 v. Arduino", count: 5, price: 370.0, idProductRM: "14234")
//    let project = Project(name: "Test Project", itemsProject: [IP1, IP2, IP3])
//    context.insert(project)
//
//    return ProjectDetailView(project: project)
//        .modelContainer(container)
//}
