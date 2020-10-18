//
//  ArticleViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        articleCollectionViewSetting()
    }
}

extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func articleCollectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
        let cellHeight: CGFloat = 437
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 20
        let insetY: CGFloat = 0
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Article", for: indexPath)
        
        //TODO: Configure cell
        return cell
    }
    
    
}


extension ArticleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
