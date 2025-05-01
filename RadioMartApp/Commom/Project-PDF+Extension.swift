//
//  Project+Extension.swift
//  RadioMartApp
//
//  Created by XMaster on 21.04.25.
//
import Foundation

import SwiftUI
import PDFKit
import FlowPDF
import SwiftData

extension Project: ReportPDFProtocol {
    var pdfDocument: PDFDocument? {
        PDFDocument(data: PDFdata)
    }

    var PDFdata: Data {createPDF()}
    
    func createPDF() -> Data {
        let pdfGenerator = FlowPDF(paper: .A4_portrait)
        let title = FlowPDFText(name)
        title.paragraphStyle.alignment = .center
        title.fontOfText = .init(name: "Arial", size: 16)!
        pdfGenerator.insertItem(title)
        
        //  # | 10027 | Name | price | count | sum
        
        
        let widthCollumns: [CGFloat] = [5, 12, 53, 10, 10, 10]
        let headers = ["№".l, "reference.report-string".l, "name.report-string".l, "price.report-string".l, "count.report-string".l, "sum.report-string".l]
        var index: Int = 0
        let contentForTable: [[String]] = itemsProject.reduce([]) {
            index += 1
            return $0 + [["\(index)", "\($1.idProductRM)", "\($1.name)", "\($1.price)", "\($1.count)", "\($1.price + Decimal($1.count))"]]
        }
        
        
        let table = FlowPDFTable(headers, widthCollumns: widthCollumns, newFont: .boldSystemFont(ofSize: 12))
        table.marginTop = 20
        table.marginRight = 5
        table.marginLeft = 5
        table.collAlignment[1] = .center
        table.collAlignment[2] = .center
        table.collAlignment[3] = .center
        table.collAlignment[4] = .center
        table.collAlignment[5] = .center
        
        
        pdfGenerator.insertItem(table)
        
        contentForTable.forEach { row in
            let tableRow = FlowPDFTable(row, widthCollumns: widthCollumns, newFont: .boldSystemFont(ofSize: 10))
            tableRow.marginRight = 5
            tableRow.marginLeft = 5
            tableRow.setLineWidth = 1.5
            pdfGenerator.insertItem(tableRow)
        }
        
        
        let pdfData = pdfGenerator.create()
        
        return pdfData
    }

}


//
//#Preview {
//    
//    
//    struct PreviewProjectPDF: UIViewRepresentable {
//        
//        let project: Project
//        
//        func makeUIView(context: Context) -> PDFView {
//            
//            let pdfView = PDFView()
//            pdfView.document = PDFDocument(data: project.PDFdata)
//            pdfView.autoScales = true
//            return pdfView
//        }
//        
//        func updateUIView(_ pdfView: PDFView, context: Context) {
//            
//        }
//    }
//    
//    
//    
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
//    let IP1 = ItemProject(name: "Led Electron PCB component Led Electron component ", count: 99, price: 15.0, idProductRM: "10117")
//    let IP2 = ItemProject(name: "PCB", count: 4, price: 300000.0, idProductRM: "14254-12")
//    let IP3 = ItemProject(name: "Capasitor 220 uf 12 v. Arduino", count: 5, price: 370.0, idProductRM: "14234")
//    let project = Project(name: "Test Project", itemsProject: [IP1, IP2, IP3])
//    context.insert(project)
//    
//    return PreviewProjectPDF(project: project)
//        .modelContainer(container)
//        .environment(\.locale, Locale(identifier: "ru"))
//}

