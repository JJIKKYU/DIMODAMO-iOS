//
//  ReportMainVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ReportMainVC: UIViewController {
    
    let viewModel = ReportMainViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet var topView_user: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet var topView_post: UIView!
    @IBOutlet weak var postProfile: UIImageView!
    @IBOutlet weak var postNickname: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet var topView_comment: UIView!
    @IBOutlet weak var commentProfile: UIImageView!
    @IBOutlet weak var commentNickname: UILabel!
    @IBOutlet weak var commentTitle: UITextView!
    @IBOutlet weak var commentCreateAt: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    /*
     Table Header View를 신고 유형에 맞추어서 세팅
     */
    func topViewSetting(reportType: ReportType, profileImage: UIImage, nickname: String, text: String, createAt: String) {
        switch reportType {
        case .post:
            self.view.addSubview(topView_post)
            self.tableView.tableHeaderView = topView_post
            
            postProfile.image = profileImage
            postNickname.text = nickname
            postTitle.text = text
            
            
            break
            
        case .comment:
            self.view.addSubview(topView_comment)
            self.tableView.tableHeaderView = topView_comment
            
            commentProfile.image = profileImage
            commentNickname.text = nickname
            commentTitle.text = text
            commentCreateAt.text = createAt
            
            break
            
        case .user:
            self.view.addSubview(topView_user)
            self.tableView.tableHeaderView = topView_user
            
            userProfile.image = profileImage
            
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 종료 버튼을 눌렀을 경우
    @IBAction func pressedCloseBtn(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // 신고 내용 작성을 끝내고, 완료 버튼을 누를 경우
    @IBAction func pressedApplyBtn(_ sender: Any) {
        // 신고 로직 호출
    }
    
    
}

// MARK: - TableView

extension ReportMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
        
        let index = indexPath.row
        
        cell.textLabel?.text = viewModel.reportArr[index]
        
        return cell
    }
    
    
}
