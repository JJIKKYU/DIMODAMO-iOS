//
//  NoticeVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/24.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import WebKit

import RxRelay
import RxSwift
import RxCocoa

class NoticeVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: String?
    
    let urlRelay = BehaviorRelay<String>(value: "")
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        urlRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                if url.count > 0 {
                    self?.loadUrl()
                }
            })
            .disposed(by: disposeBag)
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
        guard let url = URL(string: "\(self.urlRelay.value)") else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
}
