//
//  ArticleDetailViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

class ArticleDetailViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var articleCategory: UILabel!
    
    var article: Article?
    
    var titleRelay = BehaviorRelay<String>(value: "로딩중입니다")
    
    var disposeBag = DisposeBag()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 이 페이지에서 나갈때 라지 타이틀을 비활성화 했으므로 다시 활성화 해주고 나감
        navigationController?.visible(color: UIColor.appColor(.textBig))
        
        // 하단 탭바 다시 보이도록
        (self.tabBarController as? TabBarViewController)?.visible()
        
        // < 이전 버튼 다시 원래 컬러로 변경
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray170)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
        navigationController?.invisible()
        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
        
        // 하단 탭바 숨기기
        (self.tabBarController as? TabBarViewController)?.invisible()
        
        titleRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.navigationItem.title = "\(value)"
                self?.titleLabel.text = "\(value)"
            })
            .disposed(by: disposeBag)

    }
}


extension ArticleDetailViewController {
    func viewDesign() {
        articleCategory.articleCategoryDesign()
    }
}
