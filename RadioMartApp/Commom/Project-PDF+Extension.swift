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

extension Project {
    
    
    
    @MainActor
    func makePDFSnapshot(companyName: String) -> ProjectPDFSnapshot{
        var index: Int = 0
        let rowsFromProject:[[String]] = itemsProject.reduce([]) {
            index += 1
            return $0 + [["\(index)", "\($1.idProductRM)", "\($1.name)", "\($1.price)", "\($1.count)", "\($1.price * Decimal($1.count))"]]
        }
        
        return ProjectPDFSnapshot(
            
            companyName: companyName,
            projectName: name,
            rows: rowsFromProject
        )
    }

    static func createPDF(context: ProjectPDFSnapshot) -> Data{

        let pdfGenerator = FlowPDF(paper: .A4_portrait)
        let companyName = FlowPDFText(context.companyName)
        
        companyName.paragraphStyle.alignment = .right
        companyName.fontOfText = .init(name: "Arial", size: 14)!
        pdfGenerator.insertItem(companyName)
        
        let title = FlowPDFText(context.projectName)
        title.paragraphStyle.alignment = .center
        title.fontOfText = .init(name: "Arial", size: 16)!
        pdfGenerator.insertItem(title)
        
        //  # | 10027 | Name | price | count | sum
        
        
        let widthCollumns: [CGFloat] = [5, 12, 53, 10, 10, 10]
        let headers = ["№".l, "reference.report:string".l, "name.report:string".l, "price.report:string".l, "count.report:string".l, "sum.report:string".l]
        let contentForTable = context.rows
        
        
        let table = FlowPDFTable(headers, widthCollumns: widthCollumns, newFont: .boldSystemFont(ofSize: 10))
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
            let tableRow = FlowPDFTable(row, widthCollumns: widthCollumns, newFont: .systemFont(ofSize: 10))
            tableRow.marginRight = 5
            tableRow.marginLeft = 5
            tableRow.setLineWidth = 1.5
            pdfGenerator.insertItem(tableRow)
        }
        
        return pdfGenerator.create()
    }

}

struct ProjectPDFSnapshot: Sendable {
    let companyName: String
    let projectName: String
    let rows: [[String]]
}


