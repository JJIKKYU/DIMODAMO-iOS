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
 
 protocol CreatePostTagTextFieldUpdate {
     func updateTags(tags: [String])
 }

class CreateTagsVC: UIViewController {
    
    let viewModel = CreateTagsViewModel()
    var disposbag = DisposeBag()
    
    var tagTextDelegate : CreatePostTagTextFieldUpdate? = nil
    
    @IBOutlet weak var tagTextField: UITextField!
    
    // 태그 목록 추가 컬렉션 뷰
    @IBOutlet weak var tagListCollectionView: UICollectionView!
    
    // 분리선 콘스트레인트
    @IBOutlet weak var divideLineTopConstraint: NSLayoutConstraint! {
        didSet {
            // 테스트용
//            divideLineTopConstraint.constant = 100
        }
    }
    @IBOutlet weak var addBtn: UIButton! {
        didSet {
            addBtn.isEnabled = false
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tagTextDelegate?.updateTags(tags: self.viewModel.inputTagsRelay.value)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 로드될 경우에 키보드 올라오도록
        tagTextField.becomeFirstResponder()
    }
    
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
            .subscribe(onNext: { [weak self] value in
                // '추가' 컬러 변경
                if value.count >= 2 {
                    self?.tagBtn.setTitleColor(UIColor.appColor(.system), for: .normal)
                    
                } else {
                    self?.tagBtn.setTitleColor(UIColor.appColor(.gray190), for: .normal)
                }
                
                if value.count >= 10 {
                    
                }
            })
            .disposed(by: disposbag)
        
        // 태그가 2개 모두 작성 되었을 경우 버튼 활성화
        viewModel.inputTagsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value.count >= 2 {
                    self?.addBtn.backgroundColor = UIColor.appColor(.system)
                    self?.addBtn.isEnabled = true
                } else {
                    self?.addBtn.backgroundColor = UIColor.appColor(.gray210)
                    self?.addBtn.isEnabled = false
                }
            })
            .disposed(by: disposbag)
        
        /*
         Keyboard
         */
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 텍스트필드 비우기
    @IBAction func pressedTextfieldDeleteBtn(_ sender: Any) {
        self.tagTextField.text = nil
    }
    
    // 태그 추가 버튼
    @IBAction func tagAddBtn(_ sender: Any) {
        self.addTag()
        self.tagListCollectionView.reloadData()
    }
    
    // 삽입하기 버튼
    @IBAction func tagAddCompleteBtn(_ sender: Any) {
        tagTextDelegate?.updateTags(tags: self.viewModel.inputTagsRelay.value)
        print("태그를 전달합니다. \(self.viewModel.inputTagsRelay.value)")
        self.navigationController?.popViewController(animated: true)
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
 extension CreateTagsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TagDeleteBtn {
    
    func pressedDeleteBtn(index: Int) {
        var tags = self.viewModel.inputTagsRelay.value
        tags.remove(at: index)
        self.viewModel.inputTagsRelay.accept(tags)
        tagListCollectionView.reloadData()
        
        // 태그의 개수가 0개일 경우
        if self.viewModel.inputTagsCount == 0 {
            // 태그 자리 다시 없애기
            self.divideLineTopConstraint.constant = 24
        }
    }
    
    func collectionViewSetting() {
        // width, height 설정
//        let cellWidth: CGFloat = 84
//        let cellHeight: CGFloat = 26
        
//        let layout = tagListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        layout.scrollDirection = .horizontal
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.inputTagsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.tagListCollectionView.reloadData()
        let index = indexPath.row
        print("sizeforat : \(index)")
        print("업데이트 하는 셀 \(self.viewModel.inputTagsRelay.value[index])")
        
        var size: CGFloat?
        if let font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 14) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let myText = "#\(self.viewModel.inputTagsRelay.value[index])"
            size = ((myText as NSString).size(withAttributes: fontAttributes).width) + 14 + 14 + 4 + 16
        }
        // 28은 양 옆 마진
        return CGSize(width: size ?? 200, height: 26)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePostTagCompleteCell", for: indexPath) as! CreatePostTagCompleteCell
        
        let index = indexPath.row
        let model = self.viewModel.inputTagsRelay.value
        
        cell.tagTextLabel.text = "#\(model[index])"
        cell.tagTextLabel.layer.cornerRadius = (cell.tagTextLabel.frame.height + 4 + 5)  / 2
        cell.tagTextLabel.layer.masksToBounds = true
        cell.tagIndex = index
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
    }
    
}


// MARK: - Tag TextField
extension CreateTagsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 10글자 제한
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        
        // Get your textFields text
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        // Check if the last character is a space
        // If true then move to the next textfield
        guard str.last != nil else {
            return true
        }
        
        if str.last! == " "{
            print("SPACE!")
            self.addTag()
            self.tagTextField.text = nil
        }
        else{
            print(str.last!)
        }

        return count <= 10
    }
    
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.addBtn.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }

    @objc func moveDownTextView() {
        self.addBtn.transform = .identity
    }
}

 
 extension CreateTagsVC {
    func addTag() {
        let tag: String = self.tagTextField.text!
        let trimmedString = tag.trimmingCharacters(in: .whitespaces)
        
        // 태그를 입력하지 않았을 경우 리턴
        if trimmedString.count == 0 {
            self.tagTextField.text = nil
            print("태그를 입력해 주세요")
            return
        }
        
        var tags: [String] = self.viewModel.inputTagsRelay.value
        
        // 태그가 이미 2개 이상인 경우 리턴
        if tags.count >= 2 {
            let alert = AlertController(title: "태그는 2개까지 추가 할 수 있습니다", message: "", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive) { action in
                return
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        print("tag : \(trimmedString)")
        
        tags.append(trimmedString)
        print("태그목록 : \(tags)")
        self.viewModel.inputTagsRelay.accept(tags)
        self.divideLineTopConstraint.constant = 66
        
        print("태그 카운트 : \(self.viewModel.inputTagsRelay.value.count)")
        
        self.tagTextField.text = nil
        self.tagListCollectionView.collectionViewLayout.invalidateLayout()
        self.tagListCollectionView.reloadData()
        let layout = tagListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        self.tagListCollectionView.setCollectionViewLayout(layout, animated: true)
    }
 }

 
