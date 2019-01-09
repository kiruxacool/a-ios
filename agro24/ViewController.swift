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
import Firebase

var myContext = 0

class ViewController: UIViewController, WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else {
            print("could not convert message body to dictionary: \(message.body)")
            return
        }
        
        guard let type = body["type"] as? String else {
            print("could not convert body[\"type\"] to string: \(body)")
            return
        }
        
        switch type {
        case "outerHTML":
            guard let outerHTML = body["outerHTML"] as? String else {
                print("could not convert body[\"outerHTML\"] to string: \(body)")
                return
            }
            print("outerHTML is \(outerHTML)")
        default:
            print("unknown message type \(type)")
            return
        }
    }
    
    
 
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var startView: UIView!
    @IBOutlet var progressIndicator: UIActivityIndicatorView!
    @IBOutlet var navBarPanel: UINavigationBar!
    @IBOutlet var navBar: UINavigationItem!
    
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func backButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func rightButton(_ sender: Any) {
        callNumber(phoneNumber: "+74951210000")
    }
    
    
    var remoteConfig: RemoteConfig?
    var popupWebView: WKWebView?
    var mainUrl = URL(string: "https://agro24.ru/")!
    var theBool: Bool = false
    var myTimer: Timer?
    var didWebViewLoaded: Bool = false
    
    
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        progressIndicator.startAnimating()
        webView.becomeFirstResponder()
    }
    
    open override func viewDidLoad() {
        let _ = RCValues.sharedInstance.getStartPage()!
        super.viewDidLoad()
        
        webView.navigationDelegate = self as WKNavigationDelegate
        webView.uiDelegate = self as WKUIDelegate
        webView.addObserver(self, forKeyPath: "title", options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)
       // webView.addObserver(self, forKeyPath: "loading", options: .new, context: &myContext)

        
        
        loadWebView()
    
        
//        navBar.leftBarButtonItem?.isEnabled = true
//        navBar.leftBarButtonItem?.action = #selector(back)
//
//        let newBtn = UIBarButtonItem(title: "new", style: .plain, target: self, action: #selector(back))
//        self.navBar.leftItemsSupplementBackButton = true
//        self.navBar.leftBarButtonItem = newBtn//self.navigationItem.leftBarButtonItems = [newBtn,anotherBtn]
//        self.navBar.backBarButtonItem = newBtn
//        self.navBar.setLeftBarButton(newBtn, animated: true)
//
        
        //navBar.backBarButtonItem?.style
        
        
    }
    
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
        
        // Getting
        
        
        
        
        
        
//        let jsString = "function a(){return $('#ag-header-main > div.header__level.-second > div > div > ul > li.-active > a > span').text()}; a();"
//        webView.evaluateJavaScript(jsString, completionHandler: { (innerHTML, error ) in
//            self.setTitle(title: innerHTML, error: error)
//        })
//
//        if (keyPath == "loading") {
//            backButton.isEnabled = webView.canGoBack
//            return
//        }
//
//        if keyPath == "title" {
//
//            if let title = change[NSKeyValueChangeKey.newKey] as? String {
//                self.navigationItem.title = title
//
//
//
//                //print(String(title))
//            }
//            return
//        }
        if keyPath == "estimatedProgress" {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress;
                if progress == 1 {
                    showWebView()
                }
                
            }
            return
        }
        return
    }
    
    func loadWebView() {
            let urlRequest = URLRequest(url: self.mainUrl)
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
            self.setToken()
            //navBarPanel.isHidden = false
        }
        
    }
    
    func setTitle(title: Any?, error: Error?) -> Void {
        if(title != nil) {
            let title = title as! String
            if(title != "") {
                self.navBar.title = title
            } 
        }
             
    }
    
    func setToken() {
        let defaults = UserDefaults.standard
        if let fcmToken = defaults.string(forKey: "fcmtokenstring") {
            let jsString = "function a() {agro_globals.registerDeviceToken('\(fcmToken)', 2)}; a();";
            webView.evaluateJavaScript(jsString, completionHandler: { (innerHTML, error ) in
                            print(error)
                        })
            print("token set \(fcmToken)")
        }
    }
    
  
}

extension ViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        showWebView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if (didWebViewLoaded == true) {
            progressView.isHidden = false
        }
    }


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
            decisionHandler(.allow)
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


