//
//  DomesticWebViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/5/26.
//  Copyright © 2021 1. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

enum DomesticWebProtocol {
    case http
    case other
    case key
}

class DomesticWebViewController: DomesticBaseViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var navHiddenButtonItem: UIBarButtonItem!

    public var urls: String = ""
    public var type: DomesticWebProtocol = .http
    private var wkWebView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        loadURL(urlString: urls)
        navHiddenButtonItem.title = ""
        navHiddenButtonItem.isEnabled = false
    }

    private func initWebView() {
        self.view.addSubview(wkWebView)
        wkWebView.navigationDelegate = self
        wkWebView.translatesAutoresizingMaskIntoConstraints = false

        wkWebView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        wkWebView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        wkWebView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func loadURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        wkWebView.customUserAgent = "iPhoneInWebView"
        wkWebView.load(request)
    }

    @IBAction func didClickHidden(_ sender: UIBarButtonItem) {
        wkWebView.topAnchor.constraint(equalTo: self.topView.bottomAnchor).isActive = true
    }

    @IBAction func didClickDismissBtn(_ sender: UIBarButtonItem) {
        clickDismissBtn()
    }
}

extension DomesticWebViewController: WKNavigationDelegate, WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let str = navigationAction.request.url?.absoluteString, type == .key else {
            decisionHandler(.allow)
            return
        }
        if str.contains(find: "appstore") || str.contains(find: "a9") || str.contains(find: "mdsv") || str.contains(find: "dgesy5d") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.navHiddenButtonItem.title = "收起"
                self.navHiddenButtonItem.isEnabled = true
            }
        } else {
            guard let url = URL(string: str) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        decisionHandler(.allow)
    }
}
