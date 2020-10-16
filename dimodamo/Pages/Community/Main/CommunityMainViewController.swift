//
//  CommunityMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/20.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import WebKit

class CommunityMainViewController: UIViewController {
    
    private let imageView = UIImageView(image: UIImage(named: "searchIcon"))
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // UI 및 delegate 세팅
        tableView.delegate = self
        tableView.dataSource = self
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        settingTableView()
        
        setupUI()
        
        
        // 바인딩
        
    }
    
    
    // 디모다모 교과서 타이틀을 눌렀을 경우
    @IBAction func pressedArticleTitle(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.article)", sender: sender)
    }
    
    // 디모다모 교과서 더보기를 눌렀을 경우
    @IBAction func pressedArticleMoreBtn(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.article)", sender: sender)
    }
    
    @IBAction func pressedInformationTitle(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.information)", sender: sender)
    }
    @IBAction func pressedInformationMoreBtn(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.information)", sender: sender)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func setupUI() {
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
}

extension CommunityMainViewController: UITableViewDataSource, UITableViewDelegate {
    func settingTableView() {
        tableView.rowHeight = 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블뷰마다 분기
        switch tableView.tag {
        // 아티클일 경우
        case 0:
            return 2
        // 유인물일 경우
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블뷰마다 분기
        switch tableView.tag {
        // 아티클일 경우
        case 0:
            return UITableViewCell()
        // 유인물일 경우
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath)
//
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 테이블뷰마다 분기
        switch tableView.tag {
        // 아티클일 경우
        case 0:
            return CGFloat(CellHeight.articleHeight)
        // 유인물일 경우
        case 1:
            return CGFloat(CellHeight.informationHeight)
        default:
            return 0
        }
    }
}

/// WARNING: Change these constants according to your project's design
private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 18
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 18
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}
