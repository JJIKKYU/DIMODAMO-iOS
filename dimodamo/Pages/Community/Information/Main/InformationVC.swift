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

class InformationVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loadingView: LottieLoadingView!
    
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
                    self?.loadingView.isHidden = false
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
        
        return cell
    }
    
    
}
