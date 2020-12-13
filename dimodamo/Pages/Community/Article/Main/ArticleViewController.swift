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

import GoogleMobileAds

class ArticleViewController: UIViewController {
    
    let viewModel = ArticleViewModel()
    var disposeBag = DisposeBag()
    
    // 구글 광고
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Sorting Popup
    
    // 최신글, 스크랩순, 댓글순을 보여주는 라벨
    @IBOutlet weak var articleSortingLabel: UILabel!
    var dimView: UIView! {
        didSet {
            self.view.addSubview(dimView)
            dimView.frame = UIScreen.main.bounds
            dimView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            dimView.isHidden = true
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.clickedDimView(_:)))
            dimView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func clickedDimView(_ sender:UITapGestureRecognizer){
        print("Dimview를 클릭했습니다.")
        
        self.hideSortingPopupView()
    }
    
    
    @IBOutlet var sortingPopupView: SortingPopupView! {
        didSet {
            self.view.addSubview(sortingPopupView)
            sortingPopupView.translatesAutoresizingMaskIntoConstraints = false
            sortingPopupView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            sortingPopupView.heightAnchor.constraint(equalToConstant: 178).isActive = true
            sortingPopupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            sortingPopupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
            sortingPopupView.isHidden = true
        }
    }
    
    @IBAction func pressedSortingBtn(_ sender: Any) {
        
        self.showSortingPopupView()
        print("클릭했습니다.")
    }
    
    func hideSortingPopupView() {
        dimView?.isHidden = true
        sortingPopupView.isHidden = true
    }
    
    func showSortingPopupView() {
        self.view.bringSubviewToFront(dimView)
        self.view.bringSubviewToFront(sortingPopupView)
        dimView?.isHidden = false
        sortingPopupView.isHidden = false
    }
    
    @IBAction func pressedSortingDate(_ sender: Any) {
        print("최신순으로 정렬합니다.")
        viewModel.sortingOrder.accept(.date)
        hideSortingPopupView()
        viewModel.postDataSetting()
    }
    
    @IBAction func pressedSortingScrap(_ sender: Any) {
        print("스크랩 순으로 정렬합니다.")
        viewModel.sortingOrder.accept(.scrap)
        hideSortingPopupView()
        viewModel.postDataSetting()
    }
    
    @IBAction func pressedSortingComment(_ sender: Any) {
        print("댓글 순으로 정렬합니다.")
        viewModel.sortingOrder.accept(.comment)
        hideSortingPopupView()
        viewModel.postDataSetting()
    }
    
//MARK: - View Loading
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.postDataSetting()
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadBannerAd()// 광고 로드
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        collectionView.delegate = self
        collectionView.dataSource = self
        articleCollectionViewSetting()
        dimView = UIView()
        
        viewModel.postsLoading
            .observeOn(MainScheduler.instance)
            .map { $0 == true }
            .subscribe(onNext: { [weak self] value in
                if value == true {
                    self?.collectionView.reloadData()
                    self?.collectionView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        

        /*
         구글 광고 로드
         */
        // In this case, we instantiate the banner with desired ad size.
        // 테스트용 : ca-app-pub-3940256099942544/2934735716
        // 서비스용 : ca-app-pub-1168603177352985/3339402643
        
        bannerView.adUnitID = API.admobKey
        bannerView.rootViewController = self
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
        // Empty Xib 설정, 아티클 포스트가 없을 경우 띄움
        let nibName = UINib(nibName: "EmptyCollectionCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "EmptyCollectionCell")
        
        let loadingNibName = UINib(nibName: "LoadingCollectionViewCell", bundle: nil)
        collectionView.register(loadingNibName, forCellWithReuseIdentifier: "LoadingCollectionViewCell")
        
        
        
        let cellAspectHeight: CGFloat = (437 / 414) * UIScreen.main.bounds.width
        
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
        let cellHeight: CGFloat = cellAspectHeight
        print("aspecthHeight = \(cellAspectHeight)")
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.articlePosts.count
        
        // 콘텐츠 준비 중이라는 셀을 띄울 것
        if count == 0 {
            return 1
        }
        
        if count > 4 {
            return 4
        } else {
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if viewModel.postsLoading.value == false { return UICollectionViewCell() }
        // 콘텐츠가 아직 없음!
        if viewModel.articlePosts.count == 0 && viewModel.postsLoading.value == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionCell", for: indexPath) as! EmptyCollectionCell
            
            cell.settingImageSizeLabel(cellKinds: .artboard, text: "곧 컨텐츠가 만들어질 예정이예요")
            return cell
        }
        
        if viewModel.articlePosts.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionViewCell", for: indexPath)
            return cell
        }
        
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
        // 콘텐츠가 아직 없음!
        if viewModel.articlePosts.count == 0 {
            return
        }
        
        //        print("\(viewModel.articlePosts[indexPath.row].boardId)")
        performSegue(withIdentifier: "DetailArticleVC", sender: [PostKinds.article.rawValue, indexPath.row])
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: 414, height: 100)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ArticleHeader", for: indexPath) as! ArticleHeaderReusableView
        
        let label: String = Sort.getTextLabel(sort: self.viewModel.sortingOrder.value)
        header.sortingLabel.text = "\(label)"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellAspectHeight: CGFloat = (437 / 414) * UIScreen.main.bounds.width
        
        return CGSize(width: UIScreen.main.bounds.width - 40, height: cellAspectHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPostion = scrollView.contentOffset.y
        print(yPostion)
        
        if yPostion < 70 {
            navItem.title = ""
        } else {
            navItem.title = "디모 아트보드"
        }
    }
}

//extension ArticleViewController: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        UIView.animate(withDuration: 0.5, animations: {
//            self.navigationController?.navigationBar.prefersLargeTitles = (velocity.y < 0)
//        })
//    }
//}


//MARK: - Googld Ads

extension ArticleViewController {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.backgroundColor = UIColor.appColor(.white255)
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func loadBannerAd() {
        // Step 2 - Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
            // Here safe area is taken into account, hence the view frame is used
            // after the view has been laid out.
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        
        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        // Step 4 - Create an ad request and load the adaptive banner ad.
        bannerView.load(GADRequest())
    }
}
