//
//  ArticleViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Kingfisher

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 최신글, 스크랩순, 댓글순을 보여주는 라벨
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet var sortingPopupView: SortingPopupView! {
        didSet {
//            self.view.bringSubviewToFront(sortingPopupView)
            self.view.addSubview(sortingPopupView)
            sortingPopupView.translatesAutoresizingMaskIntoConstraints = false
            sortingPopupView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            sortingPopupView.heightAnchor.constraint(equalToConstant: 178).isActive = true
            sortingPopupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            sortingPopupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
            self.view.layoutIfNeeded()
            sortingPopupView.isHidden = true
        }
    }
    
    let viewModel = ArticleViewModel()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        collectionView.delegate = self
        collectionView.dataSource = self
        articleCollectionViewSetting()
        
        viewModel.postsLoading
            .observeOn(MainScheduler.instance)
            .map { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
                self?.collectionView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "DetailArticleVC":
            
            segue.destination.hidesBottomBarWhenPushed = true
            guard let sender = sender as? [Int] else {
                return
            }
            
            // 0일 경우 Article, 1일 경우 Information
            let postKind: Int = sender[0]
            let postIndex: Int = sender[1]
            
            let destination: ArticleDetailViewController
                = segue.destination as! ArticleDetailViewController
            destination.viewModel.postKindRelay.accept(postKind)
            
            if let postUid = viewModel.articlePosts[postIndex].boardId {
                destination.viewModel.postUidRelay.accept(postUid)
            }
            
            if let title = viewModel.articlePosts[postIndex].boardTitle {
                destination.viewModel.titleRelay.accept("\(title)")
            }
            
            if let tags = viewModel.articlePosts[postIndex].tags {
                destination.viewModel.tagsRelay.accept(tags)
            }
            
            // 썸네일은 넘어갈 때 부드럽게 하기 위해서 prepare에서 전달
            if let titleImg = viewModel.articlePosts[postIndex].images?[0],
               let titleImgURL = URL(string: titleImg) {
                
                destination.viewModel.thumbnailImageRelay.accept(titleImgURL)
            }
            
            break
            
        default:
            break
        }
        
        
        
    }
    
    
    @IBAction func pressedSortingBtn(_ sender: Any) {
        sortingPopupView.isHidden = false
        print("클릭했습니다.")
    }
}

// MARK: - ViewDesign
extension ArticleViewController {
    func viewDesign() {
//        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.textBig),
//                          NSAttributedString.Key.font:  UIFont(name: "Apple SD Gothic Neo Bold", size: 24) as Any]
//
//        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
}

// MARK: - TableView

extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func articleCollectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
        let cellHeight: CGFloat = 437
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articlePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Article", for: indexPath) as! ArticleCell
        
        let model = viewModel.articlePosts[indexPath.row]
        
        if let loadedImage = viewModel.articlePosts[indexPath.row].images?[0],
           let loadedImageURL = URL(string: loadedImage) {
            cell.image.kf.setImage(with: loadedImageURL)
        }
        
        if let title = model.boardTitle {
            cell.title.text = title
        }
        
        
        // tags에 있는 어레이의 개수만큼 세팅
        if let tags = model.tags {
            tags.enumerated().forEach{ index, tag in
                cell.tags[index].text = "#\(tag)"
            }
        }
        
        if let nickname = model.nickname,
           let type = model.userDpti {
            cell.nickname.text = nickname
            cell.nickname.textColor = UIColor.dptiColor(type)
            cell.profile.image = UIImage(named: "Profile_\(type)")
        }
        
        if let scrapCount = model.scrapCount {
            cell.scrapCnt.text = "\(scrapCount)"
        }
        
        if let commentCount = model.commentCount {
            cell.commentCnt.text = "\(commentCount)"
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("\(viewModel.articlePosts[indexPath.row].boardId)")
        performSegue(withIdentifier: "DetailArticleVC", sender: [PostKinds.article.rawValue, indexPath.row])
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 414, height: 100)
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ArticleHeader", for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20)
    }
    
    
}


//extension ArticleViewController: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        UIView.animate(withDuration: 0.5, animations: {
//            self.navigationController?.navigationBar.prefersLargeTitles = (velocity.y < 0)
//        })
//    }
//}
