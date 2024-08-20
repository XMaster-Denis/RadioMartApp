import Foundation
import WebKit

public final class SVGLoader {
    let html: String

    public struct Style {
        var rawCSS: String = """
            svg {
                width: 100vw;
                height: 100vh;
            }
            """
    }
    
    private struct HtmlBuilder {
        
        public func buildHtml(svg: String, style: Style) -> String {
            return """
            <!doctype html>
            <html>
            
            <head>
            <meta charset="utf-8"/>
            <style>
            \(style.rawCSS)
            </style>
            </head>
            
            <body>
            \(svg)
            </body>
            
            </html>
            """
        }
        
    }


    init?(named: String, style: Style, bundle: Bundle) {
        guard
            
            let url = bundle.url(forResource: named, withExtension: "svg"),
            let data = try? Data(contentsOf: url),
            let svg = String(data: data, encoding: .utf8) else {
                print("svg file not found")
                return nil
        }
        self.html = HtmlBuilder().buildHtml(svg: svg, style: style)
    }
    
}
