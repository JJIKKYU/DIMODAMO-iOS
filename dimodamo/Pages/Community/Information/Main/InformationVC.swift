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

class InformationVC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loadingView: LottieLoadingView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    // 구글 광고
    var bannerView: GADBannerView!
    
    let viewModel = InformationViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
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
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest()) // 광고 로드
        
        
    }
    @IBAction func pressedPlusBtn(_ sender: Any) {
        performSegue(withIdentifier: "CreatePostVC", sender: nil)
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
            for (index, tag) in tags.enumerated() {
                cell.tags[index].text = "#\(tag)"
                cell.tags[index].isHidden = false
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
