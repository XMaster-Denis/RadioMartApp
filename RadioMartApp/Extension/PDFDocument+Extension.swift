//
//  PDFDocument+Extension.swift
//  RadioMartApp
//
//  Created by XMaster on 15.08.2024.
//

import Foundation
import PDFKit
import SwiftUI

extension PDFDocument: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .pdf) { pdf in
                if let data = pdf.dataRepresentation() {
                    return data
                } else {
                    return Data()
                }
            } importing: { data in
                if let pdf = PDFDocument(data: data) {
                    return pdf
                } else {
                    return PDFDocument()
                }
            }
        DataRepresentation(exportedContentType: .pdf) { pdf in
            if let data = pdf.dataRepresentation() {
                return data
            } else {
                return Data()
            }
        }
     }
    
    
    func pdfPreviewImage() -> Image {
        guard let page = self.page(at: 0) else {
            return Image(systemName: "doc.richtext")
        }
        
        let pageBounds = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageBounds.size)
        
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageBounds)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageBounds.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            ctx.cgContext.drawPDFPage(page.pageRef!)
        }
        
        return Image(uiImage: image)
    }
}

extension PDFDocument {
    func savePDFToTemporaryFile(pdfData: Data) -> URL? {
        // Создаем временный файл
        let tempDirectory = FileManager.default.temporaryDirectory
        let pdfURL = tempDirectory.appendingPathComponent("example.pdf")
        
        do {
            // Записываем PDF данные в файл
            try pdfData.write(to: pdfURL)
            return pdfURL
        } catch {
            print("Error saving PDF to file: \(error)")
            return nil
        }
    }
}
