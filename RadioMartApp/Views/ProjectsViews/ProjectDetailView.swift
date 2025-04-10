//
//  ProjectDetailView.swift
//  RadioMartApp
//
//  Created by XMaster on 30.12.2023.
//

import SwiftUI
import SwiftData
import PDFKit


struct ProjectDetailView: View {
    @StateObject var project: Project
    @State var currentItem: ItemProject?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var isEditingItem: Bool = false
    @State var isEditingTitle: Bool = false
    @State var anchor: UnitPoint = .center
    @State var newTitleProject = ""
    @State private var showModalPDF = false
    @State private var showShareSheet = false
    @State private var isExporting = false
    @State private var pdfURL: URL?
    
    var body: some View {
        GeometryReader { fullPage in
            
            ZStack {
                VStack (spacing: 0) {
                    
                    HStack (spacing: 0) {
                        if isEditingTitle {
                            ValidationForm { valid in
                                IconTextField("enter.a.new.project.name-string", text: $newTitleProject, modField: {
                                    $0.textFieldStyle(.roundedBorder)
                                }, modIcon: {
                                    $0.hidden()
                                }) {
                                    !newTitleProject.isEmpty
                                }
                                
                                Button("save:string") {
                                    withAnimation {
                                        project.name = newTitleProject
                                        isEditingTitle = false
                                    }
                                }
                                .buttonStyle(.bordered)
                                .disabled(!valid)
                                
                            }
                            
                            
                            
                            
                        } else {
                            HStack {
                                Text(project.name)
                                    .font(.title)
                                    .frame(maxWidth: .infinity)
                                    .onLongPressGesture {
                                        withAnimation {
                                            isEditingTitle = true
                                            newTitleProject = project.name
                                            
                                        }
                                    }
                                Button("exportpdf-string") {
                                    self.showModalPDF = true
                                    // path.projectsPath.append(project)
                                    // ItemsListFromProjectPDFView
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    if project.itemsProject.isEmpty {
                        Text("in.this.project.dont.item-string")
                            .padding()
                    } else
                    {
                        Table(project.itemsProject.sorted{$0.dateAdd < $1.dateAdd})
                        {
                            
                            TableColumn("name-string"){ item in
                                if horizontalSizeClass == .compact {
                                    ItemRowDetailForIPhoneView(item: item)
                                        .onTapGesture {
                                            withAnimation(.linear(duration: 0.4)) {
                                                currentItem = item
                                                isEditingItem.toggle()
                                            }
                                        }
                                } else {
                                    Text(String(item.name))
                                }
                            }
                            
                            TableColumn("reference-string", value: \.idProductRM)
                                .width(100)
                            
                            TableColumn("count-string"){ item in
                                HStack {
                                    Text(String(item.count))
                                    Spacer()
                                    VStack {
                                        Button("", systemImage: "chevron.up.circle") {
                                            item.count += 1
                                        }
                                        Button("", systemImage: "chevron.down.circle") {
                                            item.count -= 1
                                        }
                                        .disabled(item.count <= 1)
                                    }
                                }
                            }
                            .width(65)
                            
                            TableColumn("price-string"){ item in
                                Text(item.price.toLocateCurrencyString())
                            }
                            .width(90)
                            
                            TableColumn("summa-string"){ item in
                                Text(item.sumItem.toLocateCurrencyString())
                            }
                            .width(100)
                            
                            TableColumn(" "){ item in
                                
                                GeometryReader{ geometry in
                                    VStack {
                                        Button("", systemImage: "pencil") {
                                            withAnimation(.linear(duration: 0.4)) {
                                                currentItem = item
                                                //print(currentItem!.name)
                                                
                                                isEditingItem.toggle()
                                                //   print(geometry.frame(in: .global).midX)
                                                //   print(fullPage.size.width)
                                                let x = geometry.frame(in: .global).maxX / fullPage.size.width
                                                let y = geometry.frame(in: .global).minY / fullPage.size.height
                                                
                                                //   print(x)
                                                //   print(y)
                                                
                                                anchor = .init(
                                                    x: x,
                                                    y: y)
                                            }
                                        }
                                        .font(.title)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                
                            }
                            .width(20)
                        }
                        .disabled(isEditingItem)
                    }
                    
                    
                    
                }
                if isEditingItem {
                    if let currentItem = currentItem {
                        ItemManagerView(item: currentItem, isEditingItem: $isEditingItem)
                            .transition(
                                AnyTransition.scale(scale: 0.0, anchor: anchor)
                                
                            )
                    }
                }
            }
            .sheet(isPresented: $showModalPDF) {
                VStack {
                    if let pdfDocument = PDFDocument(data: project.PDFdata) {
                        let wrapper = PDFDocumentWrapper(pdfDocument: pdfDocument, fileName: project.name)
                        

                        if let pdfURL = wrapper.savePDFToTemporaryFile() {
                            ShareLink(item: pdfURL, preview: SharePreview("\(project.name).pdf", image: wrapper.pdfPreviewImage())) {
                                Label("sharepdf-string", systemImage: "square.and.arrow.up")
                            }
                            .padding()
                        }
                        

//                        ShareLink(item: wrapper, preview: SharePreview("fileName123.pdf", image: wrapper.pdfPreviewImage())) {
//                            Label("Share PDF (via Wrapper)", systemImage: "square.and.arrow.up")
//                        }
                    }
                    
                    // Отображение содержимого PDF
                    PDFSwiftUIView(PDFdata: project.PDFdata)
                }
            }
//            .sheet(isPresented: $showModalPDF) {
//                VStack {
//                    if let pdfDocument = PDFDocument(data: project.PDFdata) {
//                        if let pdfURL = pdfDocument.savePDFToTemporaryFile(pdfData: project.PDFdata){
//                            ShareLink(item: pdfURL/*, preview: SharePreview("fi23.pdf", image: Image("icon_pdf") pdfDocument.pdfPreviewImage()*/) {
//                                Label("Share PDF", systemImage: "square.and.arrow.up")
//                            }
//                        }
//                        let shareablePDF = ShareablePDF(pdfDocument: pdfDocument, fileName: "fileName123")
//                        
//                        ShareLink(item: shareablePDF, preview: SharePreview("fileName123.pdf", image: Image("icon_pdf") /*pdfDocument.pdfPreviewImage()*/)) {
//                            Label("Share PDF", systemImage: "square.and.arrow.up")
//                        }
//                    }
//                    PDFSwiftUIView(PDFdata: project.PDFdata)
//                }
//                
//                
//            }
            
        }
        
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
    
    
    let IP1 = ItemProject(name: "Led Electron PCB component Led Electron component ", count: 99, price: 15.0, idProductRM: "10117")
    let IP2 = ItemProject(name: "PCB", count: 4, price: 300000.0, idProductRM: "14254-12")
    let IP3 = ItemProject(name: "Capasitor 220 uf 12 v. Arduino", count: 5, price: 370.0, idProductRM: "14234")
    let project = Project(name: "Test Project", itemsProject: [IP1, IP2, IP3])
    context.insert(project)
    
    return ProjectDetailView(project: project)
        .modelContainer(container)
}
