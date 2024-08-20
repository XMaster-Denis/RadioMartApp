//
//  PDF.swift
//  RadioMartApp
//
//  Created by XMaster on 15.01.2024.
//

import SwiftUI
import PDFKit
import FlowPDF

struct PDFGeneratorFromFlowView: UIViewRepresentable {

    func makeUIView(context: Context) -> PDFView {
        let pdfGenerator = FlowPDF(paper: .A4_portrait)
        
        // Default margins for pages on all sides are 20
        pdfGenerator.margins.left = 30
        pdfGenerator.margins.right = 30
        
        // Create a regular large headline
        let title = FlowPDFText("Example title for a document")
        
        // Center it and increase the font size
        title.paragraphStyle.alignment = .center
        title.fontOfText = .init(name: "Arial", size: 24)!
        
        // After configuring the object, we will add it to the vpvp class object.
        // Depending on the sequential addition of these objects, the content will be displayed on the pages.
        // It makes no difference when to add them immediately after the configuration or all of them at the end.
        pdfGenerator.insertItem(title)
        
        
        let title2 = FlowPDFText("Here we will place information that should be placed on the right side of the page. For example, full name, position, etc.")
        
        title2.fontOfText = .italicSystemFont(ofSize: 18)
        // You can create your own indents for each object
        title2.marginLeft = 300 // This line creates a half-page indent on the left
        title2.marginRight = 5
        title2.marginTop = 20
        title2.marginBottom = 20

        guard let img = UIImage(systemName: "wand.and.stars") else {fatalError()}
        let imgFlowPDF = FlowPDFImage(img)
        
        // Using this parameter, you can ignore the dimensions of the previous object and place it, for example, on the same line as the previous object.
        imgFlowPDF.ignoreYOffset = true
        
        // We can set the dimensions of an object by specifying the desired values.
        imgFlowPDF.heightContent = 150
        imgFlowPDF.widthContent = 150
        
        
        let title3 = FlowPDFText("For example, let's add regular text here. Let's say we want to align it in width. The following example will show how to use a full-fledged object of the class AttributedString as text")
        title3.paragraphStyle.alignment = .justified
        title3.fontOfText = .init(name: "Arial", size: 14)!
        
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 14.0)! ]
        let myAttributedString = NSMutableAttributedString(string: "Last name First name", attributes: myAttribute )
        let attrString = NSAttributedString(string: " Position      ______________________________")
        myAttributedString.append(attrString)
        var myRange = NSRange(location: 17, length: 5)
        myAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: myRange)
        myRange = NSRange(location: 3, length: 17)
        let anotherAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
        myAttributedString.addAttributes(anotherAttribute, range: myRange)
        
        let title4 = FlowPDFText(myAttributedString)
        title4.marginTop = 40
        
        // We insert all previous objects into the PDF file
        pdfGenerator.insertItem(title2)
        pdfGenerator.insertItem(imgFlowPDF)
        pdfGenerator.insertItem(title3)
        pdfGenerator.insertItem(title4)

        
        // Add an image with a signature
        guard let signature = UIImage(systemName: "signature") else {fatalError()}

        let pdfSignature = FlowPDFImage(signature)
        pdfSignature.ignoreYOffset = true
        pdfSignature.heightContent = 75
        pdfSignature.widthContent = 75
        pdfSignature.marginLeft = 300
        pdfGenerator.insertItem(pdfSignature)
        
        let your_signatureText = FlowPDFText("Your signature")
        your_signatureText.marginTop = 0
        your_signatureText.marginLeft = 280
        // Let's add an indent below after this line
        your_signatureText.marginBottom = 20
        pdfGenerator.insertItem(your_signatureText)
        
        
        let tableTitle = FlowPDFText("Let's work with tabular data")
        
        tableTitle.fontOfText = .boldSystemFont(ofSize: 24)
        tableTitle.paragraphStyle.alignment = .center
        tableTitle.marginBottom = 20
        pdfGenerator.insertItem(tableTitle)
        
        
        pdfGenerator.insertItem(FlowPDFText("The trick of this library is that we don’t need to think about the size of the previous object and we can add objects one by one. The library itself will create a new PDF sheet if necessary, or split the table into rows between sheets."))
        
        
        
        
        
        let widthCollumns: [CGFloat] = [20, 60, 20]
        let headers = ["Referense i i i i i i i", "It is a fuul dectripton t is a fuul dectr t is a i i iis a fuul dectripton t is a fuul dectr t is a i i ii i  i i i  fuun t is a fuul dectr t is a i i iis a fuul dectripton t is a fuul dectr t is a i i ii i  i i i  fuul dectr t is a fuul dectr", "Prise i i i i i i i i i i i i"]
        
        var led = [["1  10037-8", "It is a LED. Ligtd Color is ra LED. Ligtd Color is ra LED. Ligtd Color is ra LED. Ligtd Color is red", "15 Tenge"],
                   ["2  30037-8", "1It is a LED. Ligtd Color is red", "215 Tenge"],
                   ["3  40037-8", "It is a LED. Ligtd Color is red", "88 Tenge"]]
        
        let led2 = [["4  10037-8", "It is a LED. Ligtd Co a LED. Ligtd Co a LED. Ligtd Color is red", "15 Tenge"],
                   ["5  20037- 8037-8", "Ligtd Color is red", "20 Tenge"],
                   ["6  40037-8", "It is a LED. Ligtd Color is red", "88 Tenge"]]
        
        
        
        
        let pdfLogo30_2 = FlowPDFImage(signature)
        pdfLogo30_2.heightContent = 50
        pdfLogo30_2.widthContent = 50
         
        let pdfLogo50_2 = FlowPDFImage(signature)
        pdfLogo50_2.heightContent = 100
        pdfLogo50_2.widthContent = 50
        
        let someRow: [FlowPDFContentProtocol] = [pdfLogo30_2, pdfLogo50_2, FlowPDFText(myAttributedString)]
         
        
        
        let table = FlowPDFTable(headers, widthCollumns: widthCollumns)
        table.marginTop = 60
        table.marginRight = 20
        table.marginLeft = 20
        
        
        pdfGenerator.insertItem(table)
        
        let tableSomeRow = FlowPDFTable(someRow, widthCollumns: widthCollumns)
        tableSomeRow.marginTop = 0
        tableSomeRow.marginRight = 20
        tableSomeRow.marginLeft = 20
        tableSomeRow.setLineWidth = 5
        tableSomeRow.collAlignment[0] = .right
        tableSomeRow.collAlignment[1] = .center
        
        pdfGenerator.insertItem(tableSomeRow)
        
        
        
        led.append(contentsOf: led2)
        led.forEach { row in
            let tableRow = FlowPDFTable(row, widthCollumns: widthCollumns)
            tableRow.marginTop = 30
            tableRow.marginRight = 20
            tableRow.marginLeft = 20
            tableRow.setLineWidth = 1.5
            pdfGenerator.insertItem(tableRow)
        }
        

        
        let title6 = FlowPDFText("6666 66666 66666 66666 66666 6666 66666 6666 6 ")
        pdfGenerator.insertItem(title6)

        
        
        let pdfData = pdfGenerator.create()
        
        let pdfView = PDFView()
        
     
       
        pdfView.document = PDFDocument(data: pdfData)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        
    }
    
}


#Preview {
    PDFGeneratorFromFlowView()
}
