//
//  LinkWebViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import WebKit

import RxSwift
import RxRelay
import RxCocoa

class LinkWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var url = BehaviorRelay<URL?>(value: URL(string: ""))
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        url
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.loadUrl(url: self!.url.value!)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUrl(url: URL) {
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
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
