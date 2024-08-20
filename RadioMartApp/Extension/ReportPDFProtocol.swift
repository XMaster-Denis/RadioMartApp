//
//  ReportPDFProtocol.swift
//  RadioMartApp
//
//  Created by XMaster on 11.08.2024.
//

import Foundation
import SwiftUI
import PDFKit

public protocol ReportPDFProtocol {
    var PDFdata: Data {get}
  //  var PDFdataRepresentation: Data {get}
    var pdfDocument: PDFDocument? {get}
    func createPDF() -> Data
}
