//
//  ViewController.swift
//  AGRO24
//
//  Created by Кирилл on 25/10/2018.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import WebKit
import Foundation

var myContext = 0

class ViewController: UIViewController, WKNavigationDelegate {
    
 
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var startView: UIView!
    @IBOutlet var progressIndicator: UIActivityIndicatorView!
    @IBOutlet var navBar: UINavigationItem!
    
    
    var popupWebView: WKWebView?
    var mainUrl = URL(string: "https://agro24.ru/")!
    var theBool: Bool = false
    var myTimer: Timer?
    var didWebViewLoaded: Bool = false
    
    
    
    open override func viewWillAppear(_ animated: Bool) {
        progressIndicator.startAnimating()
        webView.becomeFirstResponder()
    }
    
    open override func viewDidLoad() {
     
        super.viewDidLoad()
        
        webView.navigationDelegate = self as WKNavigationDelegate
        webView.uiDelegate = self as WKUIDelegate
        webView.addObserver(self, forKeyPath: "title", options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)

        loadWebView()
    
        navBar.hidesBackButton = false
        navBar.leftBarButtonItem?.isEnabled = true
        navBar.leftBarButtonItem?.action = #selector(back)
        
    
        //navBar.backBarButtonItem.hi
    }
    
//
    @objc public func back(sender: UIBarButtonItem) {
        if(webView.canGoBack) {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated:true)
        }
    }
    
    //observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "title" {
            
            if let title = change[NSKeyValueChangeKey.newKey] as? String {
                self.navigationItem.title = title
                //print(String(title))
            }
            return
        }
        if keyPath == "estimatedProgress" {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress;
                if progress == 1 {
                    showWebView()
                }
                
            }
            return
        }
    }
    
    
    
    
    
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//     //   progressBar?.setProgress(1, animated: true)
//
//        print("end")
//    }
//
    
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
    
    func showWebView() {
        if didWebViewLoaded == true {
           return
        } else {
            progressIndicator.stopAnimating()
            startView.isHidden = true
            webView.isHidden = false
            didWebViewLoaded = true
        }
        
    }
    
  
}

extension ViewController: WKUIDelegate {
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if let url = navigationAction.request.url {
//            if url.absoluteString.contains("/something") {
//                // if url contains something; take user to native view controller
//                //Routing.showAnotherVC(fromVC: self)
//                decisionHandler(.cancel)
//            } else if url.absoluteString.contains("done") {
//                //in case you want to stop user going back
//                //hideBackButton()
//                //addDoneButton()
//                decisionHandler(.allow)
//            } else if url.absoluteString.contains("AuthError") {
//                //in case of erros, show native allerts
//            }
//            else{
//                decisionHandler(.allow)
//            }
//        }
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        showWebView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if (didWebViewLoaded == true) {
            progressView.isHidden = false
        }
    }

//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        progressBar?.setProgress(100, animated: true)
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        progressBar?.setProgress(100, animated: true)
//    }
    
    
//}
//
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if navigationAction.navigationType == .linkActivated {
//            print("navi start")
//
//         //  progressBar?.setProgress(0, animated: false)
//        }
//
//        if navigationAction.navigationType == .formSubmitted {
//            print("form start")
//            //progressBar?.setProgress(0, animated: false)
//        }
//
//        if navigationAction.navigationType == .other {
//            print("other start")
//            //progressBar?.setProgress(0, animated: false)
//        }
//
//         decisionHandler(.allow)
//
//    }

    
//
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {


//        WKNavigationTypeLinkActivated,
//        WKNavigationTypeFormSubmitted,
//        WKNavigationTypeBackForward,
//        WKNavigationTypeReload,
//        WKNavigationTypeFormResubmitted,
//        WKNavigationTypeOther
//
        
        let url = navigationAction.request.url
        
        if navigationAction.targetFrame == nil {
            print("opened")
            print(UIApplication.shared.canOpenURL(url!))
            UIApplication.shared.open(url!)
            decisionHandler(.cancel)
            return
        }
        
        if navigationAction.navigationType == .linkActivated {


            

            if (url?.description.lowercased().range(of: "tel:") != nil ||
                url?.description.lowercased().range(of: "vk.com") != nil ||
                url?.description.lowercased().range(of: "facebook") != nil ||
                url?.description.lowercased().range(of: "twitter") != nil ||
                url?.description.lowercased().range(of: "ok.ru") != nil ||
                url?.description.lowercased().range(of: "mail.ru") != nil ||
                url?.description.lowercased().range(of: "google") != nil ||
                url?.description.lowercased().range(of: "agro24.ru") == nil) {

                 print(UIApplication.shared.canOpenURL(url!))
                UIApplication.shared.open(url!)
                decisionHandler(.cancel)
                
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }

    }

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

