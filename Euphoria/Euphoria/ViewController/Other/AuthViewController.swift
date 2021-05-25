//
//  AuthViewController.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate, GradientBackground {

    @IBOutlet weak var webView: WKWebView!
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        
        webView.navigationDelegate = self
        
        guard
            let url = AuthManager.shared.signInURL
        else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url
        else { return }
        
        // Exchange the code for access token
        let components = URLComponents(string: url.absoluteString)
        
        guard let code = components?.queryItems?.first(where: { $0.name == "code"})?.value
        else { return }
        
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code, completion: { [weak self] success in
            DispatchQueue.main.async {
                self?.completionHandler?(success)
            }
        })
    }
}
