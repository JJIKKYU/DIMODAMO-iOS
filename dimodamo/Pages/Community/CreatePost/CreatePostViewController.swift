//
//  CreatePostViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Tagging

class CreatePostViewController: UIViewController, TaggingDataSource {
    
    @IBOutlet weak var descriptionContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLimit: UILabel!
    
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var tagsLimit: UILabel!
    @IBOutlet weak var tagsTableView: UITableView! {
        didSet {
            tagsTableView.layer.borderWidth = 2
            tagsTableView.layer.borderColor = UIColor.appColor(.white235).cgColor
            tagsTableView.appShadow(.s4)
            tagsTableView.rowHeight = 50
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLimit: UILabel!
    
    @IBOutlet weak var tagging: Tagging! {
        didSet {
            tagging.accessibilityIdentifier = "Tagging"
            tagging.textView.accessibilityIdentifier = "TaggingTextView"
            tagging.defaultAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.gray170),
                                         NSAttributedString.Key.font:  UIFont(name: "Apple SD Gothic Neo Medium", size: 16) as Any]
            tagging.taggedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColor(.gray170),
                                        NSAttributedString.Key.font:  UIFont(name: "Apple SD Gothic Neo Medium", size: 16) as Any]
            tagging.textView.textContainer.maximumNumberOfLines = 2
            //            tagging.textView.text = nil
            
            let text: String = "태그를 입력해 주세요"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo Medium", size: 16) as Any,
                .foregroundColor : UIColor.appColor(.gray210),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            tagging.textView.attributedText = attributedString
            
            tagging.symbol = "#"
            tagging.tagableList = ["DOOMFIST", "GENJI", "MCCREE", "PHARAH", "REAPER", "SOLDIER:76", "SOMBRA", "TRACER", "BASTION", "HANZO", "JUNKRAT", "MEI", "TORBJORN", "WIDOWMAKER", "D.VA", "ORISA", "REINHARDT", "ROADHOG", "WINSTON", "ZARYA", "ANA", "BRIGITTE", "LUCIO", "MERCY", "MOIRA", "SYMMETRA", "ZENYATTA", "디자이너", "한글", "디질래", "디지몬"]
        }
    }
    
    var disposeBag = DisposeBag()
    let viewModel = CreatePostViewModel()
    
    var matchedList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        //        tagging.textView.delegate = self
        tagging.dataSource = self
        
        tagsTableView.dataSource = self
        tagsTableView.delegate = self
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        
        
        /*
         타이틀
         */
        titleTextField.rx.text.orEmpty
            .map { $0 as String }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] value in
                self?.viewModel.titleRelay.accept(value)
                self?.titleLimit.text = self?.viewModel.titleLimit
                self?.checkMaxLength(textField: self!.titleTextField, maxLength: 20)
            })
            .disposed(by: disposeBag)
        
        
        
        viewModel.titleRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                
            })
            .disposed(by: disposeBag)
        
        /*
         태그
         */
        tagging.textView.rx.text.orEmpty
            .map { $0 as String }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if self?.viewModel.tagsLimitCount == 3 {
                    print("더이상 글을 쓸 수 없도록")
                }
                self?.viewModel.tagsRelay.accept(value)
                self?.tagsLimit.text = self?.viewModel.tagsLimit
                

            })
            .disposed(by: disposeBag)
        
        /*
         내용
         */
        descriptionTextView.rx.text.orEmpty
            .map { $0 as String }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.viewModel.descriptionRelay.accept(value)
                self?.descriptionLimit.text = self?.viewModel.descriptionLimit
                
                print(value)
            })
            .disposed(by: disposeBag)
    }
    
    func tagging(_ tagging: Tagging, didChangedTagableList tagableList: [String]) {
        matchedList = tagableList
        if matchedList.count > 0 {
            tagsTableView.reloadData()
            tagsTableView.isHidden = false
        } else if matchedList.count == 0 {
            tagsTableView.reloadData()
            tagsTableView.isHidden = true
        }
        
        print(matchedList.count)
    }
    
    func tagging(_ tagging: Tagging, didChangedTaggedList taggedList: [TaggingModel]) {
        print("태그완료된 리스트 :  \(taggedList)")
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedCompleteBtn(_ sender: Any) {
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
//        self.tagsTableView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("asd")
    }
}

// MARK: - UI Design

extension CreatePostViewController {
    func viewDesign() {
        self.descriptionContainer.layer.borderWidth = 1.5
        self.descriptionContainer.layer.borderColor = UIColor.appColor(.white245).cgColor
        self.descriptionContainer.layer.cornerRadius = 9
        self.descriptionContainer.layer.masksToBounds = true
        
        
        
        tagsTableView.isHidden = true
    }
}

// MARK: - TextField

extension CreatePostViewController: UITextFieldDelegate {
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if ((textField.text!).count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    // 내용 본문에 Height에 맞게 조절하기 위해
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}

// MARK: - TagsTableView

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.tagLabel.text = matchedList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tagging.updateTaggedList(allText: tagging.textView.text, tagText: matchedList[indexPath.row])
        tableView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
