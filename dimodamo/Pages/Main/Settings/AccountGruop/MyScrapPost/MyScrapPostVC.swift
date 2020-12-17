//
//  MyScrapPostVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Kingfisher

class MyScrapPostVC: UIViewController {
    
    let viewModel = MyScrapPostViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var articleBtn: UIButton!
    @IBOutlet weak var informationBtn: UIButton!
    @IBOutlet weak var articleUnderBar: UIView! {
        didSet {
            articleUnderBar.layer.cornerRadius = 2
            articleUnderBar.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var informationUnderBar: UIView! {
        didSet {
            informationUnderBar.layer.cornerRadius = 2
            informationUnderBar.layer.masksToBounds = true
            informationUnderBar.isHidden = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableViewSetting()
        
        self.viewModel.isLoadingRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value == true {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func pressedArticleBtn(_ sender: Any) {
        self.viewModel.scrapKinds.accept(.article)
        
        self.articleUnderBar.isHidden = false
        self.informationUnderBar.isHidden = true
        
        self.articleBtn.isSelected = true
        self.informationBtn.isSelected = false
        self.tableView.reloadData()
    }
    
    @IBAction func pressedInformationBtn(_ sender: Any) {
        self.viewModel.scrapKinds.accept(.information)
        
        self.articleUnderBar.isHidden = true
        self.informationUnderBar.isHidden = false
        
        self.articleBtn.isSelected = false
        self.informationBtn.isSelected = true
        self.tableView.reloadData()
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


// MARK: - TableView

extension MyScrapPostVC: UITableViewDelegate, UITableViewDataSource {
    func tableViewSetting() {
        let nibName = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ArticleTableViewCell")
        
        let nibName_information = UINib(nibName: "Scrap_InformationTableViewCell", bundle: nil)
        tableView.register(nibName_information, forCellReuseIdentifier: "Scrap_InformationTableViewCell")
        
        // Empty Xib 설정, DPTI를 안했을 경우, 그리고 결과값이 없을 경우에 해당
        let EmptyNibname = UINib(nibName: "EmptyTableViewCell", bundle: nil)
        tableView.register(EmptyNibname, forCellReuseIdentifier: "EmptyTableViewCell")
        
        let loadingNibName = UINib(nibName: "LoadingTableViewCell", bundle: nil)
        tableView.register(loadingNibName, forCellReuseIdentifier: "LoadingTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.scrapKinds.value == .article {
            let count = self.viewModel.scrapArticleListRelay.value.count
            return count == 0 ? 1 : count
        }
        else if self.viewModel.scrapKinds.value == .information {
            let count = self.viewModel.scrapInformationListRelay.value.count
            return count == 0 ? 1 : count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 아티클 경우에 테이블 세팅
        if self.viewModel.scrapKinds.value == .article {
            
            // 스크랩한 글이 없을 경우
            if self.viewModel.scrapArticleListRelay.value.count == 0 && self.viewModel.isLoadingRelay.value == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
                cell.settingImageSizeLabel(cellKinds: .scrap, text: "아직 스크랩한 글이 없어요")
                tableView.rowHeight = 375
                return cell
            }
            
            // 아직 0개의 리스트를 가지고있지만, 로딩 중일때는 로딩바
            if viewModel.scrapArticleListRelay.value.count == 0 && self.viewModel.isLoadingRelay.value == false {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
                return cell
            }
            // 높이 세팅
            tableView.rowHeight = 487
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
            
            let index = indexPath.row
            let model = self.viewModel.scrapArticleListRelay.value[index]
            
            cell.nickname.text = model.author
            
            if let title: String = model.title {
                cell.title.text = title
            }
            
            if let dptiType: String = model.author_type {
                cell.profile.image = UIImage(named: "Profile_\(dptiType)")
                cell.nickname.textColor = UIColor.dptiDarkColor(dptiType)
            }
            if let tags: [String] = model.tags {
                for (index, tag) in cell.tags.enumerated() {
                    tag.text = "#\(tags[index])"
                }
            }
            
            
            if let imageThumb: String = model.thumb_image {
                let imageUrl = URL(string: imageThumb)
                cell.titleImage.kf.setImage(with: imageUrl)
            }
            
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        // 인포메이션 경우 테이블 세팅
        else if self.viewModel.scrapKinds.value == .information {
            
            // 스크랩한 글이 없을 경우
            if self.viewModel.scrapInformationListRelay.value.count == 0 && self.viewModel.isLoadingRelay.value == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
                cell.settingImageSizeLabel(cellKinds: .scrap, text: "아직 스크랩한 글이 없어요")
                tableView.rowHeight = 375
                return cell
            }
            
            // 아직 0개의 리스트를 가지고있지만, 로딩 중일때는 로딩바
            if viewModel.scrapInformationListRelay.value.count == 0 && self.viewModel.isLoadingRelay.value == false {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
                return cell
            }
            
            // 높이 세팅
            tableView.rowHeight = 150
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Scrap_InformationTableViewCell", for: indexPath) as! Scrap_InformationTableViewCell
            
            let index = indexPath.row
            let model = self.viewModel.scrapInformationListRelay.value[index]
            
            cell.nickName.text = model.author
            
            if let title: String = model.title {
                cell.title.text = title
            }
            
            if let dptiType: String = model.author_type {
                cell.profile.image = UIImage(named: "Profile_\(dptiType)")
                cell.nickName.textColor = UIColor.dptiDarkColor(dptiType)
            }
            if let tags: [String] = model.tags {
                for (index, tag) in cell.tags.enumerated() {
                    tag.text = "#\(tags[index])"
                }
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let storyboard = UIStoryboard(name: "Community", bundle: nil)
        let articleDetailVC = storyboard.instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailViewController
        
        if self.viewModel.scrapKinds.value == .article {
            let model = self.viewModel.scrapArticleListRelay.value[index]
            
            articleDetailVC.viewModel.postKindRelay.accept(PostKinds.article.rawValue)
            
            if let uid = model.uid {
                articleDetailVC.viewModel.postUidRelay.accept(uid)
            }
            
            if let title = model.title {
                articleDetailVC.viewModel.titleRelay.accept(title)
            }
            
            if let tags = model.tags {
                articleDetailVC.viewModel.tagsRelay.accept(tags)
            }
            
            if let titleImg = model.thumb_image,
               let titleImgURL = URL(string: titleImg) {
                articleDetailVC.viewModel.thumbnailImageRelay.accept(titleImgURL)
            }
            
            navigationController?.pushViewController(articleDetailVC, animated: true)
        }
        
        else if self.viewModel.scrapKinds.value == .information {
            articleDetailVC.viewModel.postKindRelay.accept(PostKinds.information.rawValue)
            let model = self.viewModel.scrapInformationListRelay.value[index]
            
            if let uid = model.uid {
                articleDetailVC.viewModel.postUidRelay.accept(uid)
            }
            
            if let title = model.title {
                articleDetailVC.viewModel.titleRelay.accept(title)
            }
            
            if let tags = model.tags {
                articleDetailVC.viewModel.tagsRelay.accept(tags)
            }
            
            navigationController?.pushViewController(articleDetailVC, animated: true)
        }
    }
    
    
    
}
