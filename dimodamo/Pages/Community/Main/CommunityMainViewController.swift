//
//  CommunityMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/20.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import WebKit

import RxSwift
import RxCocoa

import Kingfisher


class CommunityMainViewController: UIViewController {
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    // Paging Variable (articleCollectionView)
    var currentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    let viewModel = CommunityMainViewModel()
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillAppear")
        navigationController?.visible(color: UIColor.appColor(.textBig))
        navigationController?.view.backgroundColor = .white
//        self.navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        
        // UI 및 delegate 세팅
        tableView.delegate = self
        tableView.dataSource = self
        
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        
        settingTableView()
        articleCollectionViewSetting()
        //        setupUI()
        
        viewModel.articleLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : {[weak self] loading in
                if loading == true {
                    self?.articleCollectionView.reloadData()
                    self?.articleCollectionView.layoutIfNeeded()
                    self?.spinner.stopAnimating()
                } else {
                    self?.spinner.startAnimating()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - IBaction
    
    // 디모다모 교과서 타이틀을 눌렀을 경우
    @IBAction func pressedArticleTitle(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.article)", sender: sender)
    }
    
    @IBAction func pressedInformationTitle(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.information)", sender: sender)
    }
    
    @IBAction func pressedCreatePostBtn(_ sender: Any) {
        performSegue(withIdentifier: "CreatePostVC", sender: sender)
    }
    
    @IBAction func pressedSearchBtn(_ sender: Any) {
        performSegue(withIdentifier: "CommunitySearchVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        self.hidesBottomBarWhenPushed = true
        
        switch segue.identifier {
        
        // 메인에서 직접 아티클 카드를 선택했을 경우
        // sender에서는 indexpath.row가 넘어옴
        case "DetailArticleVC_Main":
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
            
            // Article일 경우 세팅
            if postKind == PostKinds.article.rawValue {
                
                
                
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
                if let titleImg = viewModel.articlePosts[postIndex].images[0] {
                    destination.viewModel.thumbnailImageRelay.accept(titleImg)
                }
                
            }
            // Information일 경우 세팅
            else if postKind == PostKinds.information.rawValue {
                
                if let postUid = viewModel.informationPosts[postIndex].boardId {
                    destination.viewModel.postUidRelay.accept(postUid)
                }
                
                if let title = viewModel.informationPosts[postIndex].boardTitle {
                    destination.viewModel.titleRelay.accept("\(title)")
                }
                
                if let tags = viewModel.informationPosts[postIndex].tags {
                    destination.viewModel.tagsRelay.accept(tags)
                }
                
                //                let tags = viewModel.informationPosts[postIndex].tags
                //                                    destination.viewModel.tagsRelay.accept(tags)
                
                
            }
            
            
            
            break
            
        case "CreatePostVC":
            //            let destination: CreatePostViewController = segue.destination as! CreatePostViewController
            segue.destination.hidesBottomBarWhenPushed = true
            segue.destination.modalTransitionStyle = .coverVertical
            segue.destination.modalPresentationStyle = .fullScreen
            
            break
            
            // 검색
        case "CommunitySearchVC":
            segue.destination.modalTransitionStyle = .coverVertical
            segue.destination.modalPresentationStyle = .fullScreen
            break
            
        case "InformationVC":
            
            break
            
        default:
            break
        }
    }
    
    // MARK: - UI

    
    
    
}

// MARK: - TableView (Information)(

extension CommunityMainViewController: UITableViewDataSource, UITableViewDelegate {
    func settingTableView() {
        tableView.rowHeight = 145
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.informationPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationTableViewCell
        
        let model = viewModel.informationPosts[indexPath.row]
        
        if let type = model.userDpti,
           let profileImage = UIImage(named: "Profile_\(type)") {
            cell.profile.image = profileImage
            cell.nickName.textColor = UIColor.dptiColor(type)
        }
        
        if let title = model.boardTitle ?? "오류가 발생했습니다" {
            cell.title.text = "\(title)"
        }
        
        if let nickname = model.nickname ?? "익명" {
            cell.nickName.text = "\(nickname)"
        }
        
        if let scrapCount = model.scrapCount ?? 0 {
            cell.scrapCnt.text = "\(scrapCount)"
        }
        
        if let commentCount = model.commentCount {
            cell.commnetCnt.text = "\(commentCount)"
        }
        
        if let tags = model.tags {
            for (index, tag) in tags.enumerated() {
                cell.tags[index].text = "\(tag)"
            }
        }
        cell.tagDesign()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        performSegue(withIdentifier: "DetailArticleVC_Main", sender: [PostKinds.information.rawValue, indexPath.row])
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        print("호출")
    //        return CGFloat(CellHeight.informationHeight)
    //    }
}

// MARK: - CollectionView (Article)

extension CommunityMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // firestore에 있는 article의 카운트만큼 가져옴
        return viewModel.articlePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Article", for: indexPath) as! ArticleCell
        
        let model = viewModel.articlePosts[indexPath.row]
        
        if let loadedImage = viewModel.articlePosts[indexPath.row].images[0] {
            cell.image.kf.setImage(with: loadedImage)
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
    
    // 선택한 아이템
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let selectedCell: ArticleCell = collectionView.cellForItem(at: indexPath) as! ArticleCell
        //        print(selectedCell)
        
        performSegue(withIdentifier: "DetailArticleVC_Main", sender: [PostKinds.article.rawValue, indexPath.row])
        //        print(indexPath.row)
    }
    
    func articleCollectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 48
        let cellHeight: CGFloat = 437
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        
        let layout = articleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        articleCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX - 4, bottom: insetY, right: insetX - 4)
        
        
        // 스크롤 시 빠르게 감속 되도록 설정
        articleCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
}



// MARK: - Article Paging

extension CommunityMainViewController : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.articleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
