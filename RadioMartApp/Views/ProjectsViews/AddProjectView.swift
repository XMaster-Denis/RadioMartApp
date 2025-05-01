//
//  AddProjectView.swift
//  RadioMartApp
//
//  Created by XMaster on 13.04.25.
//



import SwiftUI
import SwiftData

struct AddProjectView: View {
    @Environment(\.dismiss) var dismiss
    @State var newNameProject: String = ""

    
    var body: some View {
        VStack(spacing: 30) {
            Text("addingnewproject-string")
            ValidationForm { valid in
                
                IconTextField("projectname-string", text: $newNameProject) {
                    $0.textFieldStyle(.roundedBorder)
                } modIcon: { $0
                } condition: {
                    !newNameProject.isEmpty
                }
                HStack {
                    Button("cancel-string", role: .destructive) {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    //   .foregroundStyle(.red)
                    Button("add-string") {
                        ProjectsManager.shared.addNewProject(newNameProject)
                    //    ProjectsManager.shared.refreshProjects()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!valid)
                }
            }
            Spacer()
        }
        .padding()
    }
}
