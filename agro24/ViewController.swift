//
//  ViewController.swift
//  AGRO24
//
//  Created by Кирилл on 25/10/2018.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKNavigationDelegate {
    

    
    @IBOutlet var webView: WKWebView!
    var popupWebView: WKWebView?
    var mainUrl = URL(string: "https://agro24.ru")!
    
    @IBOutlet var progressBar: UIProgressView?
    
    
    
    open override func viewDidLoad() {
//        firstToolbarItem.layer.borderColor = UIColor.darkGray.cgColor
//        firstToolbarItem.layer.borderWidth = 5
        
        super.viewDidLoad()
    
        
        webView.navigationDelegate = self as WKNavigationDelegate //as? WKNavigationDelegate
        webView.uiDelegate = self as WKUIDelegate
        progressBar?.isHidden = false
        progressBar?.setProgress(0.15, animated: false)
        loadWebView()
       
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBar?.setProgress(1, animated: true)
   
        print("end")
    }
    
    
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//
//        progressBar?.setProgress(0, animated: true)
//    }
//
//
//   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//       progressBar?.setProgress(100, animated: true)
//    }
//
    
//    func setupWebView() {
//        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//        preferences.javaScriptCanOpenWindowsAutomatically = true
//
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences = preferences
//
//        webView = WKWebView(frame: view.bounds, configuration: configuration)
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
//
//        view.addSubview(webView)
//    }
    
    func loadWebView() {
        let urlRequest = URLRequest(url: mainUrl)
            webView.load(urlRequest)
       
    }

}

extension ViewController: WKUIDelegate {

//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        progressBar?.setProgress(100, animated: true)
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        progressBar?.setProgress(100, animated: true)
//    }
    
    
//}
//
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
            print("navi start")
           
            progressBar?.setProgress(0, animated: false)
        }
        
        if navigationAction.navigationType == .formSubmitted {
            print("form start")
            //progressBar?.setProgress(0, animated: false)
        }
        
        if navigationAction.navigationType == .other {
            print("other start")
            //progressBar?.setProgress(0, animated: false)
        }
        
         decisionHandler(.allow)

    }

    
    
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == .linkActivated {
//
//
//            let url = navigationAction.request.url
//
//            if url?.description.lowercased().range(of: "http://") != nil ||
//                url?.description.lowercased().range(of: "https://") != nil {
//                decisionHandler(.cancel)
//                UIApplication.shared.open(url!)
//            } else {
//                decisionHandler(.allow)
//            }
//        } else {
//            decisionHandler(.allow)
//        }
//
//    }

//    func webViewDidClose(_ webView: WKWebView) {
//        if webView == popupWebView {
//            popupWebView?.removeFromSuperview()
//            popupWebView = nil
//        }
//    }
}
//
//extension ViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView,
//                 didFinish navigation: WKNavigation!) {
//        progressBar?.setProgress(100, animated: true)
//
//    }
//}
//

