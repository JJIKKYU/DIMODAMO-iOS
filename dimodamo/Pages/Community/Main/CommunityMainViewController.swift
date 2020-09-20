//
//  CommunityMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/20.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import WebKit

class CommunityMainViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    func goWeb(postfix: String) -> () {
        let url = URL(string: "http://dimodamo.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        goWeb(postfix: "scale")
        
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
