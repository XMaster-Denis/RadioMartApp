//
//  ProjectPanelView.swift
//  RadioMartApp
//
//  Created by XMaster on 18.12.2023.
//

import SwiftUI
import SwiftData

struct ProjectPanelView: View {
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @ObservedObject var settings = SettingsManager.shared
//    @ObservedObject var activeProject = SettingsManager.shared.activProjectViewModel
    
    var body: some View {
        HStack {
            Text("currentproject:-string")
                .lineLimit(1)
                .fixedSize()
            Spacer()
            VStack (spacing:0) {
                Picker("currentproject:-string", selection: settings.activProjectViewModel) {
                    ForEach(projectsManager.projectViewModels, id: \.id) { viewModel in
                        Text("\(viewModel.project.name)")
                            .tag(viewModel)
                            .fixedSize()
                    }
                }
                .fixedSize()
                Text(settings.currentProjectViewModel.totalPrice.toLocateCurrencyString())
                    .monospacedDigit()
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    ProjectPanelView()
//}
