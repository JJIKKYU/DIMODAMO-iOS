//
//  ArticleSearchVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ArticleSearchVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let viewModel = ArticleSearchViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleCollectionViewSetting()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        viewModel.searchKeyword
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyword in
                if keyword != "" {
                    self?.viewModel.articleSearch()
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

extension ArticleSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func articleCollectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
        let cellHeight: CGFloat = 437
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Article", for: indexPath)
        
        return cell
    }
    
    
}

extension ArticleSearchVC: SendSearchTextDelegate {
    func send(keyword: String) {
        print("\(keyword)")
        print("keyword 전달 완료")
    }
    
    
}
