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
