//
//  PDFDocument+Extension.swift
//  RadioMartApp
//
//  Created by XMaster on 15.08.2024.
//

import Foundation
import PDFKit
import SwiftUI

struct PDFDocumentWrapper: Transferable {
    let pdfDocument: PDFDocument
    var fileName: String
    
    init(pdfDocument: PDFDocument, fileName: String = "project.pdf") {
        self.pdfDocument = pdfDocument
        self.fileName = fileName.hasSuffix(".pdf") ? fileName : "\(fileName).pdf"
    }


    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .pdf) { wrapper in
            if let data = wrapper.pdfDocument.dataRepresentation() {
                return data
            } else {
                return Data()
            }
        } importing: { data in
            if let pdfDocument = PDFDocument(data: data) {
                return PDFDocumentWrapper(pdfDocument: pdfDocument)
            } else {
                throw NSError(domain: "PDFDocumentWrapper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create PDFDocument from data."])
            }
        }
    }

    func pdfPreviewImage() -> Image {
        guard let page = pdfDocument.page(at: 0) else {
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

    func savePDFToTemporaryFile() -> URL? {
        guard let data = pdfDocument.dataRepresentation() else {
            return nil
        }
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let pdfURL = tempDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: pdfURL)
            return pdfURL
        } catch {
            print("Error saving PDF to file: \(error)")
            return nil
        }
    }
}

