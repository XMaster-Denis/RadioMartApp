//
//  PDFView.swift
//  RadioMartApp
//
//  Created by XMaster on 11.08.2024.
//

import Foundation
import SwiftUI
import PDFKit
import UIKit
import UniformTypeIdentifiers

struct PDFSwiftUIView: UIViewRepresentable {
    
    let PDFdata: Data
    
    
    func makeUIView(context: Context) -> PDFView {
        
        
        let pdfView = PDFView()
        
        pdfView.document = PDFDocument(data: PDFdata)
        pdfView.autoScales = true
        return pdfView
        
        
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        
    }
    
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Data]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}



struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Data]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}





struct FileDocumentInteractionController: UIViewControllerRepresentable {
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

struct PDFExportDocument: FileDocument {
    // Определяем поддерживаемые типы файлов
    static var readableContentTypes: [UTType] { [.pdf] }
    
    var pdfDocument: PDFKit.PDFDocument?
    
    init(pdfDocument: PDFKit.PDFDocument?) {
        self.pdfDocument = pdfDocument
    }
    
    // Инициализатор для загрузки документа из существующего файла
    init(configuration: ReadConfiguration) throws {
        if let pdfData = configuration.file.regularFileContents,
           let pdfDocument = PDFKit.PDFDocument(data: pdfData) {
            self.pdfDocument = pdfDocument
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    // Метод для сохранения документа в файл
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let pdfDocument = pdfDocument else {
            throw CocoaError(.fileWriteUnknown)
        }
        let data = pdfDocument.dataRepresentation() ?? Data()
        return FileWrapper(regularFileWithContents: data)
    }
}


struct ShareablePDF: Transferable {
    let pdfDocument: PDFDocument
    let fileName: String

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .pdf) { (shareablePDF: ShareablePDF) in
            
            
            
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(shareablePDF.fileName).appendingPathExtension("pdf")
            
            if let data = shareablePDF.pdfDocument.dataRepresentation() {
                try? data.write(to: tempURL)
            }
            
            return SentTransferredFile(tempURL)
        }
    }
}
