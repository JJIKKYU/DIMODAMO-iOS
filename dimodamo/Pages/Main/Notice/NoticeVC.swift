//
//  NoticeVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/24.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import WebKit

class NoticeVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadUrl()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Web kit

extension NoticeVC: WKUIDelegate, WKNavigationDelegate {
    func loadUrl() {
//        view.addSubview(webView)
        
        // WKWebview Setting
        let url = URL(string: "http://dimodamo.com")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
}
