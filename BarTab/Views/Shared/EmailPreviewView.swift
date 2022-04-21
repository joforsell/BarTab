//
//  EmailPreviewView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-21.
//

import SwiftUI
import WebKit

struct EmailPreviewView: UIViewRepresentable {
    @EnvironmentObject var userHandler: UserHandling
    @Binding var showingPreview: Bool
    @Binding var message: String
    
    let previewCustomer: Customer?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let customer = previewCustomer ?? Customer(name: "John Appleseed", balance: 600, key: "", email: "john.appleseed@apple.com")
        let html = EmailSender.makeHtml(for: customer, from: userHandler.user, with: message)
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let customer = previewCustomer ?? Customer(name: "John Appleseed", balance: 600, key: "", email: "john.appleseed@apple.com")
        let html = EmailSender.makeHtml(for: customer, from: userHandler.user, with: message)
        uiView.loadHTMLString(html, baseURL: nil)
    }
    
    typealias UIViewType = WKWebView
}
