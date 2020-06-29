//
//  WebView.swift
//  TourMaker
//
//  Created by kitaharamugirou on 2020/05/11.
//  Copyright © 2020 Kitahara, Mugiro. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol WebViewDelegate: class {
    func onReloadPage()
}

class WebView: UIViewController,WKUIDelegate,WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    var loadUrl = URL(string: "https://travel-thru.online") //現在みているページのURL
    var queries : [String] = []
    var reloadBySignin = false
    var ableToNavigate = true
    weak var delegate: WebViewDelegate?
    
    lazy var webView : WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "share");
        return webView
    }()
    
    override func viewDidLoad() {
        self.view.addSubview(webView)

    }
    
    override func viewDidLayoutSubviews() {
        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    private func addQuery(url: URL,  query:String) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = nil //delete all query from component
        
        if let prevQuery = url.query {
            if prevQuery.contains(query) {
                components?.query = query
            } else {
                 components?.query = prevQuery + "&\(query)"
            }
        } else {
            components?.query = query
        }
        return components!.url
    }
    
    func canGoBack() -> Bool {
        return self.webView.canGoBack
    }
    

    func goBack() {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        } else {
            // canGoBack == false の処理
        }
    }
    
    func reload() {
        self.webView.reload()
    }
    
    //first set url to open
    func setUrl(url : URL) {
        self.loadUrl = url
    }
    
    func hideWebAppHeader() {
        self.queries.append("header=hide")
    }
    
    func disableNavigation() {
        self.ableToNavigate = false
    }
    
    func addTemporalQuery(query:String) {
        self.loadUrl = addQuery(url:self.loadUrl! , query: query)
    }
    
    //use it after set url
    func loadWebPage()  {
        //画面遷移を考えるとクエリをつけるのはここで集中的にやりたい
        var url = addQuery(url:self.loadUrl! , query: "app=true")
        for query in queries {
            url = addQuery(url:url!, query: query)
        }
        let customRequest = URLRequest(url: url!)
        self.loadUrl = url!
        webView.load(customRequest)
    }
    
}

extension WebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if url != self.loadUrl && !self.ableToNavigate {
            decisionHandler(.cancel)
            return
        }
        
        // If base url is www.google.com, dont open it(because you cannot go back)
        print(url.absoluteString)
        if url.absoluteString.starts(with: "https://www.google.com") {
            decisionHandler(.cancel)
            return
        }
        

        // If url changes, cancel current request which has no custom parameters
        // and load a new request with that url with custom parameters
        if url != loadUrl! {
            print("url changed")
            print(url.absoluteString)
            print(loadUrl!.absoluteString)
            decisionHandler(.cancel)
            setUrl(url: url)
            loadWebPage()
         } else {
            decisionHandler(.allow)
         }
    }
    
}
