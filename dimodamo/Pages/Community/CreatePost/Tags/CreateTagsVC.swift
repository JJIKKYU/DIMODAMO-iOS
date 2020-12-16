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
    
    let viewModel = CreateTagsViewModel()
    var disposbag = DisposeBag()
    
    @IBOutlet weak var tagTextField: UITextField!
    
    // 태그 목록 추가 컬렉션 뷰
    @IBOutlet weak var tagListCollectionView: UICollectionView!
    
    // 분리선 콘스트레인트
    @IBOutlet weak var divideLineTopConstraint: NSLayoutConstraint! {
        didSet {
            divideLineTopConstraint.constant = 100
        }
    }
    
    // 자동완성 테이블뷰
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
        }
    }
    
    // 태그 추가 버튼
    @IBOutlet weak var tagBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tagListCollectionView.delegate = self
        tagListCollectionView.dataSource = self
        self.collectionViewSetting()
        
        tagTextField.delegate = self
        
        tagTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.tagTextRelay)
            .disposed(by: disposbag)
        
        
        viewModel.tagTextRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                
            })
            .disposed(by: disposbag)
        
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
        return self.viewModel.inputTagsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTagCell", for: indexPath)
        
        return cell
    }
    
    
}

// MARK: - Collection View (태그 목록)
extension CreateTagsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = 84
        let cellHeight: CGFloat = 26
        
        let layout = tagListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.inputTagsCount
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePostTagCompleteCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 84, height: 26)
    }
}

// MARK: - Tag TextField
extension CreateTagsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get your textFields text
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        // Check if the last character is a space
        // If true then move to the next textfield
        guard str.last != nil else {
            return true
        }
        
        if str.last! == " "{
            print("SPACE!")
            
            let tag: String = self.tagTextField.text!
            self.tagTextField.text = ""
            var tags: [String] = self.viewModel.inputTagsRelay.value
            tags.append(tag)
            print("태그목록 : \(tags)")
            self.viewModel.inputTagsRelay.accept(tags)
            self.divideLineTopConstraint.constant = 66
            
            print("태그 카운트 : \(self.viewModel.inputTagsRelay.value.count)")
            
            self.tagListCollectionView.reloadData()
            self.view.layoutIfNeeded()
            
        }
        else{
            print(str.last!)
        }

        return true
    }
}
