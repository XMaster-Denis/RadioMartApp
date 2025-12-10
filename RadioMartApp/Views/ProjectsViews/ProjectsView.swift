//
//  OrdersView.swift
//  RadioMartApp
//
//  Created by XMaster on 23.09.2023.
//

import SwiftUI
import SwiftData

struct ProjectsView: View {
    @EnvironmentObject var projectsManager: ProjectsManager
    @ObservedObject var path: Router = Router.shared
    @State var isAddProjectShow: Bool = false
    @State var isEditProjectName: Bool = false
    @State var selectedProjectViewModel: ProjectViewModel?
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        
        NavigationStack (path: $path.projectsPath) {
            ZStack {
                VStack {
                    HStack {
                        Text("allprojects:string")
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
                        ForEach(projectsManager.projectViewModels, id: \.idU) { projectViewModel in
                            ProjectLineView(viewModel: projectViewModel)
                                .swipeActions(allowsFullSwipe: false){
                                    
                                    Button {
                                        
                                        if  projectsManager.projectViewModels.count > 1 {
                                            projectsManager.markDeleteProject(projectViewModel)
                                        } else {
                                            showDeleteAlert = true
                                        }
                                    } label: {
                                        Label("delete:string", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    
                                    Button(role: .cancel) {
                                        withAnimation {
                                            selectedProjectViewModel = projectViewModel
                                            isEditProjectName.toggle()
                                        }
                                    } label: {
                                        Label("rename:string", systemImage: "pencil")
                                    }
                                    
                                }
                                .onTapGesture {
                                    path.projectsPath.append(projectViewModel)
                                }
                        }
                        
                    }
                    .listStyle(.plain)
                    
                    
                }
                .navigationDestination(for: ProjectViewModel.self) { project in
                    ProjectDetailView(projectViewModel: project)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem (placement: .topBarLeading) {
                                Button {
                                    path.projectsPath.removeLast()
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.backward")
                                        Text("allprojects:string")
                                    }
                                }
                            }
                        }
                }
                .disabled(isEditProjectName)
                
                if isEditProjectName {
                    if let selectedProjectViewModel = selectedProjectViewModel {
                        let inputStr = selectedProjectViewModel.name
                        IconTextFieldModalView("enter.a.new.project.name:string", isShow: $isEditProjectName, succesButton: "rename:string", inputStr: inputStr) {
                            selectedProjectViewModel.updateName($0)
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

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Project.self, configurations: config)
//    
//    for i in 1..<6 {
//        let project = Project(name: "Test Project \(i)")
//        container.mainContext.insert(project)
//    }
//    
//    return ProjectsView()
//        .modelContainer(container)
//}
