//
//  CreateTagsVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/15.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class CreateTagsVC: UIViewController {

    @IBOutlet weak var tagTextField: UITextField!
    
    // 태그 목록 추가 컬렉션 뷰
    @IBOutlet weak var tagListCollectionView: UICollectionView!
    
    // 분리선 콘스트레인트
    @IBOutlet weak var divideLineTopConstraint: NSLayoutConstraint!
    
    // 자동완성 테이블뷰
    @IBOutlet weak var tableView: UITableView!
    
    // 태그 추가 버튼
    @IBOutlet weak var tagBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tagListCollectionView.delegate = self
        tagListCollectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 텍스트필드 비우기
    @IBAction func pressedTextfieldDeleteBtn(_ sender: Any) {
    }
    
    // 태그 추가 버튼
    @IBAction func tagAddBtn(_ sender: Any) {
    }
}


// MARK: - Table View (자동완성)
extension CreateTagsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTagCell", for: indexPath)
        
        return cell
    }
    
    
}

// MARK: - Collection View (태그 목록)
extension CreateTagsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePostTagCompleteCell", for: indexPath)
        
        return cell
    }
    
    
}
