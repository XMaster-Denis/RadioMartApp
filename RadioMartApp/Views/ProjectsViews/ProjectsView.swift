//
//  OrdersView.swift
//  RadioMartApp
//
//  Created by XMaster on 23.09.2023.
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
                        DataBase.shared.addNewProject(newNameProject)
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


struct ProjectsView: View {
    @Query var projects: [Project]
    @ObservedObject var path = Router.shared
    @State var isAddProjectShow: Bool = false
    @State var isEditProjectName: Bool = false
    //  @State var newProjectName: String = ""
    @State var currentProject: Project?
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack (path: $path.projectsPath) {
            ZStack {
                VStack {
                    //                Button("removeAllProjects") {
                    //                    DataBase.shared.removeAllProjects()
                    //                }
                    //                Button("removeSettings") {
                    //                    DataBase.shared.removeSettings()
                    //                }
                    //                Button("AddNewProjects") {
                    //                    DataBase.shared.addNewProject("Second")
                    //                }
                    
                    HStack {
                        Text("allprojects-string")
                            .font(.title)
                        Spacer()
                        Button(action: {
                            isAddProjectShow.toggle()
                            
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $isAddProjectShow) {
                            AddProjectView()
                        }
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(projects.sorted(by: {$0.dateAdd < $1.dateAdd})){ project in
                            ProjectLineView(project: project)
                                .swipeActions(allowsFullSwipe: false){
                                    
                                    Button {
                                        
                                        if  DataBase.shared.totalProjectsCount() > 1 {
                                            DataBase.shared.deleteProject(project)
                                        } else {
                                            showDeleteAlert = true
                                        }
                                    } label: {
                                        Label("delete-string", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    
                                    Button(role: .cancel) {
                                        withAnimation {
                                            currentProject = project
                                            isEditProjectName.toggle()
                                        }
                                    } label: {
                                        Label("rename-string", systemImage: "pencil")
                                    }
                                    
                                }
                                .onTapGesture {
                                    path.projectsPath.append(project)
                                }
                        }
                        
                    }
                    .listStyle(.plain)
                    
                    
                }
                .navigationDestination(for: Project.self) { project in
                    ProjectDetailView(project: project)
                }
                .disabled(isEditProjectName)
                
                
                if isEditProjectName {
                    if let inputStr = currentProject?.name {
                        IconTextFieldModalView("enter.a.new.project.name-string", isShow: $isEditProjectName, succesButton: "rename-string", inputStr: inputStr) {
                            if let currentProject = currentProject {
                                currentProject.name = $0
                            }
                        }
                    }
                    
                }
            }
        }
        .alert("delete.last.project.error:string", isPresented: $showDeleteAlert) {
            Button("Ok", role: .cancel) { }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Project.self, configurations: config)
    
    for i in 1..<6 {
        let project = Project(name: "Test Project \(i)")
        container.mainContext.insert(project)
    }
    
    return ProjectsView()
        .modelContainer(container)
    
}
