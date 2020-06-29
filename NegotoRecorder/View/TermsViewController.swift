//
//  TermsViewController.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/28.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import WebKit

class TermsViewController: UIViewController,WKUIDelegate {
    var loadUrl = URL(string: "https://travel-thru.online/terms/negoto")
    
    lazy var webView : WebView = {
        let webView = WebView()
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        self.view.addSubview(webView.view)
        
        guard let url = self.loadUrl else { fatalError() }
        webView.setUrl(url: url)
        webView.hideWebAppHeader()
        webView.disableNavigation()
        webView.loadWebPage()
    }
    
    override func viewDidLayoutSubviews() {
        self.webView.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height:self.view.frame.height - self.view.safeAreaInsets.top )
    }
}
