//
//  LogoWebView.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import WebKit

struct AnimationLogoWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        guard let svgView = SVGView(named: "logorm") else {
            return WKWebView()
        }
        return svgView.webView
    }
    func updateUIView(_ webView: WKWebView, context: Context) {}
}

#Preview {
    LaunchScreenView()
}
