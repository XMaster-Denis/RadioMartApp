//
//  ProjectDetailView.swift
//  RadioMartApp
//
//  Created by XMaster on 30.12.2023.
//

import SwiftUI
import SwiftData
import PDFKit

struct DocumentInteractionController: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // Empty view controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let documentInteractionController = UIDocumentInteractionController(url: url)
        documentInteractionController.delegate = context.coordinator
        documentInteractionController.presentOptionsMenu(from: uiViewController.view.frame, in: uiViewController.view, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIDocumentInteractionControllerDelegate {
        // Implement delegate methods if necessary
    }
}

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
                    
                    HStack {
                        if isEditingTitle {
                            ValidationForm { valid in
                                IconTextField("enter.a.new.project.name-string", text: $newTitleProject, modField: {
                                    $0.textFieldStyle(.roundedBorder)
                                }, modIcon: {
                                    $0.hidden()
                                }) {
                                    !newTitleProject.isEmpty
                                }
                                
                                Button("save-string", systemImage: "square.and.arrow.down") {
                                    withAnimation {
                                        project.name = newTitleProject
                                        isEditingTitle = false
                                    }
                                }
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
                                Button("PDF") {
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
                            
                            TableColumn("Name"){ item in
                                if horizontalSizeClass == .compact {
                                    ItemRowDetailForIPhoneView(item: item)
                                        .onTapGesture {
                                            withAnimation(.linear(duration: 0.4)) {
                                                currentItem = item
                                                    // print(currentItem!.name)
                                                isEditingItem.toggle()
                                            }
                                        }
                                } else {
                                    Text(String(item.name))
                                }
                            }
                            
                            TableColumn("Reference", value: \.idProductRM)
                                .width(100)
                            
                            TableColumn("Count"){ item in
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
                            
                            TableColumn("Price"){ item in
                                Text(item.price.toLocateCurrencyString())
                            }
                            .width(90)
                            
                            TableColumn("Summa"){ item in
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
        

                   // ItemsListFromProjectPDFView(project: project)
                VStack {
//                    Button {
//                        print("send123")
//                        showModalPDF = false
//                      
//
//                                // Save the PDF to the Documents directory
//                                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                                    let pdfURL = documentsDirectory.appendingPathComponent("sample.pdf")
//                                    try? project.PDFdata.write(to: pdfURL)
//
//                                    // Store the URL and show the share sheet
//                                    self.pdfURL = pdfURL
//                                    
//                                    let url = FileManager.default.temporaryDirectory.appendingPathComponent("sample1.pdf")
//                                    do {
//                                        try project.PDFdata.write(to: url)
//                                        self.pdfURL = url
//                                        self.showShareSheet = true
//                                    } catch {
//                                        print("Could not create PDF file: \(error)")
//                                        
//                                    }
//                                    
//                                    
//                                    
//                                }
//                            
//                        
//                    } label: {
//                        Text("Send")
//                    }
                    if let pdfDocument = PDFDocument(data: project.PDFdata) {
                        if let pdfURL = pdfDocument.savePDFToTemporaryFile(pdfData: project.PDFdata){
                            ShareLink(item: pdfURL/*, preview: SharePreview("fi23.pdf", image: Image("icon_pdf") pdfDocument.pdfPreviewImage()*/) {
                                Label("Share PDF", systemImage: "square.and.arrow.up")
                            }
                        }
                        //FileDocumentInteractionController(url: pdfURL)
                      //  ActivityView(activityItems: [PDFdocument.dataRepresentation()!])
                   // ShareSheet(activityItems: [PDFdocument.dataRepresentation()!])
                      //  if let document = document {
                              //   ShareLink(item: PDFdocument, preview: SharePreview("PDF"))
                        let shareablePDF = ShareablePDF(pdfDocument: pdfDocument, fileName: "fileName123")
                               
                               ShareLink(item: shareablePDF, preview: SharePreview("fileName123.pdf", image: Image("icon_pdf") /*pdfDocument.pdfPreviewImage()*/)) {
                            Label("Share PDF", systemImage: "square.and.arrow.up")
                        }
                        
                      //  }
                       }
                    
//                    Button {
//                        print("send ui")
//                        showModalPDF = false
//                        showShareSheet = true
                      

//                                // Save the PDF to the Documents directory
//                                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                                    let pdfURL = documentsDirectory.appendingPathComponent("sample.pdf")
//                                    try? project.PDFdata.write(to: pdfURL)
//
//                                    // Store the URL and show the share sheet
//                                    self.pdfURL = pdfURL
//                                    
//                                    let url = FileManager.default.temporaryDirectory.appendingPathComponent("sample1.pdf")
//                                    do {
//                                        try project.PDFdata.write(to: url)
//                                        self.pdfURL = url
//                                        self.showShareSheet = true
//                                    } catch {
//                                        print("Could not create PDF file: \(error)")
//                                        
//                                    }
//                                }
                            
                        
//                    } label: {
//                        Text("Send ui")
//                    }
//                  
//                    Button("Export PDF") {
//                        isExporting = true
//                    }
//                    .padding()
//                    .fileExporter(
//                        isPresented: $isExporting,
//                        document: PDFExportDocument(pdfDocument: PDFDocument(data: project.PDFdata)),
//                        contentType: .pdf,
//                        defaultFilename: "ExportedDocument"
//                    ) { result in
//                        switch result {
//                        case .success(let url):
//                            print("Successfully exported to \(url)")
//                        case .failure(let error):
//                            print("Export failed with error: \(error.localizedDescription)")
//                        }
//                    }
                    
                    PDFSwiftUIView(PDFdata: project.PDFdata)
                    
                }
                //project.showPDFReport(showModalPDF)
                    
                
            }
            
//            .sheet(isPresented: $showShareSheet) {
//                if let pdfDocument = project.PDFdocument {
//                    //FileDocumentInteractionController(url: pdfURL)
//                  //  ActivityView(activityItems: [PDFdocument.dataRepresentation()!])
//               // ShareSheet(activityItems: [PDFdocument.dataRepresentation()!])
//                  //  if let document = document {
//                    
//                            
//                  //  }
//                    //ShareLink(item: PDFdocument, preview: SharePreview("PDF"))
//                    
//                    ShareLink(item: pdfDocument, preview: SharePreview("fileName.pdf", image: pdfDocument.pdfPreviewImage())) {
//                        Label("Share PDF", systemImage: "square.and.arrow.up")
//                    }
//                    
//                   }
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
