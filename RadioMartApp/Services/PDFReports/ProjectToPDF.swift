//
//  ProjectToPDF.swift
//  RadioMartApp
//
//  Created by XMaster on 11.08.2024.
//

import Foundation

import SwiftUI
import PDFKit
import FlowPDF
import SwiftData

class ProjectToPDF {
    let project: Project
    let pdfData: Data
    let pdfView: PDFView
    
    init (project: Project) {
        self.project = project
        
        
        
        
        
        let pdfGenerator = FlowPDF(paper: .A4_portrait)
        let title = FlowPDFText(project.name)
        title.paragraphStyle.alignment = .center
        title.fontOfText = .init(name: "Arial", size: 16)!
        pdfGenerator.insertItem(title)
        
        //  # | 10027 | Name | price | count | sum
        
        
        let widthCollumns: [CGFloat] = [5, 15, 50, 10, 10, 10]
        let headers = ["№".l, "reference.report-string".l, "name.report-string".l, "price.report-string".l, "count.report-string".l, "sum.report-string".l]
        var index: Int = 0
        let contentForTable: [[String]] = project.itemsProject.reduce([]) {
            index += 1
            return $0 + [["\(index)", "\($1.idProductRM)", "\($1.name)", "\($1.price)", "\($1.count)", "\($1.price + Decimal($1.count))"]]
        }
        
        
        let table = FlowPDFTable(headers, widthCollumns: widthCollumns)
        table.marginTop = 20
        table.marginRight = 10
        table.marginLeft = 10
        
        
        pdfGenerator.insertItem(table)
        
        contentForTable.forEach { row in
            let tableRow = FlowPDFTable(row, widthCollumns: widthCollumns, newFont: .boldSystemFont(ofSize: 10))
            tableRow.marginRight = 10
            tableRow.marginLeft = 10
            tableRow.setLineWidth = 1.5
            pdfGenerator.insertItem(tableRow)
        }
        
        
        pdfData = pdfGenerator.create()
        pdfView = PDFView()
        
        pdfView.document = PDFDocument(data: pdfData)
        pdfView.autoScales = true
       // return pdfView
    }
        
}
