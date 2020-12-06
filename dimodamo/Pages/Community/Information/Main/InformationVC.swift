//
//  InformationVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Lottie

import GoogleMobileAds

// DPTI 팝업
import STPopup

class InformationVC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loadingView: LottieLoadingView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    // 구글 광고
    var bannerView: GADBannerView!
    
    let viewModel = InformationViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - Sorting Popup
    
    // 최신글, 스크랩순, 댓글순을 보여주는 라벨
    @IBOutlet weak var sortingLabel: UILabel!
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
            self.view.layoutIfNeeded()
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
        self.viewModel.sortingChange()
    }
    
    @IBAction func pressedSortingScrap(_ sender: Any) {
        print("스크랩 순으로 정렬합니다.")
        viewModel.sortingOrder.accept(.scrap)
        hideSortingPopupView()
        self.viewModel.sortingChange()
    }
    
    @IBAction func pressedSortingComment(_ sender: Any) {
        print("댓글 순으로 정렬합니다.")
        viewModel.sortingOrder.accept(.comment)
        hideSortingPopupView()
        self.viewModel.sortingChange()
    }
    
//MARK: - View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
        tableView.delegate = self
        tableView.dataSource = self
        dimView = UIView()
        
        self.view.layoutIfNeeded()
        mainView.addSubview(loadingView)
        self.loadingView.centerYAnchor.constraint(equalTo: self.mainView.centerYAnchor).isActive = true
        self.loadingView.centerXAnchor.constraint(equalTo: self.mainView.centerXAnchor).isActive = true
        self.loadingView.layer.zPosition = 999
        self.view.layoutIfNeeded()
        
        viewModel.informationLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoaded in
                if isLoaded == true {
                    self?.tableView.reloadData()
                    self?.loadingView.isHidden = true
                } else {
                    self?.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        /*
         구글 광고 로드
         */
        // In this case, we instantiate the banner with desired ad size.
        // 테스트용 : ca-app-pub-3940256099942544/2934735716
        // 서비스용 : ca-app-pub-1168603177352985/3339402643
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1168603177352985/3339402643"
        bannerView.rootViewController = self
        bannerView.load(GADRequest()) // 광고 로드
        
        
    }
    
    /*
     글쓰기 버튼을 누를 경우에
     */
    @IBAction func pressedPlusBtn(_ sender: Any) {
        
        // 만약 DPTI를 진행해서 글쓰기가 가능하다면
        if viewModel.createPostisAvailable() {
            performSegue(withIdentifier: "CreatePostVC", sender: nil)
        }
        // DPTI를 진행하지 않아 글쓰기가 불가능하다면 팝업창을 띄워준다.
        else {
            DptiPopupManager.dptiPopup(popupScreen: .document, vc: self)
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch segue.identifier {
        case "DetailArticleVC":
            
            let postIndex = sender as! Int
            
            let destinationVC = destination as! ArticleDetailViewController
            
            destinationVC.viewModel.postKindRelay.accept(PostKinds.information.rawValue)
            
            if let postUid = viewModel.informationPosts[postIndex].boardId {
                destinationVC.viewModel.postUidRelay.accept(postUid)
            }
            
            if let title = viewModel.informationPosts[postIndex].boardTitle {
                destinationVC.viewModel.titleRelay.accept("\(title)")
            }
            
            if let tags = viewModel.informationPosts[postIndex].tags {
                destinationVC.viewModel.tagsRelay.accept(tags)
            }
            
            break
            
        case "CreatePostVC":
            destination.hidesBottomBarWhenPushed = true
            destination.modalTransitionStyle = .coverVertical
            destination.modalPresentationStyle = .fullScreen
            break
            
        default:
            break
        }
    }
    
    
}

//MARK: - TableView

extension InformationVC: UITableViewDelegate, UITableViewDataSource {
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
        
        if let title = model.boardTitle {
            cell.title.text = "\(title)"
        }
        
        if let nickname = model.nickname {
            cell.nickName.text = "\(nickname)"
        }
        
        if let scrapCount = model.scrapCount {
            cell.scrapCnt.text = "\(scrapCount)"
        }
        
        if let commentCount = model.commentCount {
            cell.commnetCnt.text = "\(commentCount)"
        }
        
        if let tags = model.tags {
            for (index, tag) in cell.tags.enumerated() {
                tag.text = "#\(tags[index])"
                tag.isHidden = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "DetailArticleVC", sender: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPostion = scrollView.contentOffset.y
        
        
        if yPostion < 70 {
            navItem.title = ""
        } else {
            navItem.title = "디모 레이어"
        }
        
        // Reload
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        //print("offsetY: \(offsetY) | contHeight-scrollViewHeight: \(contentHeight-scrollView.frame.height)")
        print("offsetY \(offsetY) , value : \(contentHeight - scrollView.frame.height - 50)")
        if offsetY > contentHeight - scrollView.frame.height - 50 {
            // Bottom of the screen is reached
            if !viewModel.fetchingMore {
                viewModel.paginateData()
                viewModel.informationLoading.accept(false)
            }
        }
    }
}

//MARK: - Googld Ads

extension InformationVC {
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
}
