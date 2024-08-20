import UIKit
import WebKit

public class SVGView: UIView, WKNavigationDelegate {
    public lazy var webView: WKWebView = .init(frame: self.bounds)
    private let loader: SVGLoader

    public init?(named: String) {
        let style = SVGLoader.Style()
        guard let loader = SVGLoader(named: named, style: style, bundle: .main)
            else {
                print("Image not found.")
                return nil
        }
        self.loader = loader
        super.init(frame: .zero)

        setup()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        NSLayoutConstraint.activate([
           webView.topAnchor.constraint(equalTo: topAnchor),
           webView.rightAnchor.constraint(equalTo: rightAnchor),
           webView.bottomAnchor.constraint(equalTo: bottomAnchor),
           webView.leftAnchor.constraint(equalTo: leftAnchor),
            ])
        isUserInteractionEnabled = false
        isOpaque = false
        backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        
        webView.loadHTMLString(loader.html, baseURL: nil)
    }


    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backgroundColor = .clear
        isOpaque = false
    }
}
