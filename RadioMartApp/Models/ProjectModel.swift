//
//  ProjectModel.swift
//  RadioMartApp
//
//  Created by XMaster on 15.12.2023.
//

import SwiftUI
import SwiftData
import FlowPDF
import PDFKit

@Model
final class Project: ObservableObject {
    var name: String
    var dateAdd: Date
    var customer: Customer?
    @Relationship(deleteRule: .cascade) var itemsProject = [ItemProject]()
    var isActiv: Bool = false
    
    init(name: String, itemsProject: [ItemProject] = []) {
        self.name = name
        self.itemsProject = itemsProject
        self.dateAdd = .now
    }
    
    func getProductsPrice() -> Decimal {
        var summa: Decimal = 0
                for item in itemsProject {
                    summa += Decimal(item.count) * item.price
                }
        return summa
    }
    
//    func getCountByRM (_ reference: String) -> Int {
 //       return itemsProject.filter{$0.idProductRM == reference}.reduce(0) {$0 + $1.count}
 //   }
    
    func getItemByRM (_ reference: String) -> ItemProject? {
        return itemsProject.first{$0.idProductRM == reference}
    }
    
    func incItem(item: ItemProject, count: Int = 1) {
        let findedItem = itemsProject.first{$0.idProductRM == item.idProductRM &&
            $0.price == item.price &&
            $0.name == item.name}
        guard  let findedItem = findedItem else {
            itemsProject.append(item)
            return
        }
        findedItem.count += 1
            
         //   .filter{$0.idProductRM == reference}.reduce(0) {$0 + $1.count}
    }
    
    
    func decItem(item: ItemProject, count: Int = 1) {
        if item.count > 1 {
            item.count -= 1
        } else {
            if let index = itemsProject.firstIndex(where: { $0.idProductRM == item.idProductRM }) {
                itemsProject.remove(at: index)
            }
        }
            
         //   .filter{$0.idProductRM == reference}.reduce(0) {$0 + $1.count}
    }
    
    
    func getItem(item: ItemProject) -> ItemProject{
        let findedItem = itemsProject.first{$0.idProductRM == item.idProductRM &&
            $0.price == item.price &&
            $0.name == item.name}
        guard  let findedItem = findedItem else {
            
            return item
        }
        return findedItem
        
         //   .filter{$0.idProductRM == reference}.reduce(0) {$0 + $1.count}
    }
}


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
        
        
        let widthCollumns: [CGFloat] = [5, 15, 50, 10, 10, 10]
        let headers = ["№".l, "reference.report-string".l, "name.report-string".l, "price.report-string".l, "count.report-string".l, "sum.report-string".l]
        var index: Int = 0
        let contentForTable: [[String]] = itemsProject.reduce([]) {
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
        
        
        let pdfData = pdfGenerator.create()
        
        return pdfData
    }

}





