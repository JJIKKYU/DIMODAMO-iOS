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
        tableView.rowHeight = 457
        let nibName = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.scrapPickListRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        let index = indexPath.row
        let model = self.viewModel.scrapPickListRelay.value[index]
        
        cell.nickname.text = model.author
        
        if let title: String = model.title {
            cell.title.text = title
        }
        
        if let dptiType: String = model.author_type {
            cell.profile.image = UIImage(named: "Profile_\(dptiType)")
        }
        if let tags: [String] = model.tags {
            for (index, tag) in cell.tags.enumerated() {
                tag.text = "\(tags[index])"
            }
        }
        
        
        if let imageThumb: String = model.thumb_image {
            let imageUrl = URL(string: imageThumb)
            cell.titleImage.kf.setImage(with: imageUrl)
        }
        
        
        return cell
    }
    
    
}
