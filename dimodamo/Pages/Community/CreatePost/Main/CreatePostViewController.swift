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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLimit: UILabel!
    
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var tagsLimit: UILabel!
    
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.rowHeight = UITableView.automaticDimension
            mainTableView.estimatedRowHeight = 100
        }
    }
    
    /*
     Link
     */
    
    @IBOutlet var linkPopupView: LinkPopupView! {
        didSet {
            linkPopupView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
            linkPopupView.layer.masksToBounds = true
            linkPopupView.appShadow(.s20)
        }
    }
    // 팝업이 뜰 경우 뒤를 살짝 가려주는 요도로 사용
    var dimView: UIView!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var linkInsertBtn: UIButton!
    @IBOutlet weak var linkCloseBtn: UIButton!
    
    /*
     UploadImage
     */
    var imagePicker : UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var testImageView: UIImageView!
    
    @IBOutlet weak var bottomIconContainerView: UIView! {
        didSet {
            bottomIconContainerView.layer.cornerRadius = 16
            bottomIconContainerView.layer.masksToBounds = true
            bottomIconContainerView.appShadow(.s20)
        }
    }
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
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        imagePicker.delegate = self
        
        
        
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
        
        /*
         이미지 업로드
         */
        viewModel.uploadImagesRelay
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] _ in
                self?.mainTableView.reloadData()
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        
        /*
         Keyboard
         */
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    
    
    
    /*
     IBAction & TouchAction
     */
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedCompleteBtn(_ sender: Any) {
        viewModel.sendPost()
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        //        self.tagsTableView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("asd")
    }
    
    @IBAction func pressedCameraBtn(_ sender: Any) {
        print("카메라로 사진을 촬영합니다.")
        
        // 카메라 사용 가능한지 체크
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        imagePicker.sourceType = .camera
        
        imagePicker.allowsEditing = false // 촬영 후 편집할 수 있는 부분이 나온다.
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pressedAlbumBtn(_ sender: Any) {
        
        // 카메라 사용 가능한지 체크
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = false // 촬영 후 편집할 수 있는 부분이 나온다.
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    /*
     Link
     */
    
    @IBAction func pressedLinkBtn(_ sender: Any) {
        print("링크삽입")
        self.linkTextField.becomeFirstResponder()
        
        navigationController?.hideTransparentNavigationBar()
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.backgroundColor = .clear
        dimView.isHidden = false
        linkPopupView.isHidden = false
//        linkPopupView.layer.zPosition = 999
        
    }
    
    @IBAction func pressedLinkPopupViewCloseBtn(_ sender: Any) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.presentTransparentNavigationBar()
        self.linkPopupView.isHidden = true
        self.dimView.isHidden = true
        self.linkTextField.resignFirstResponder()
    }
    @IBAction func pressedLinkInsertBtn(_ sender: Any) {
        print("링크를 삽입합니다")
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
        
        // 팝업뷰가 보이지 않더라도 먼저 constraint 세팅
        linkPopupViewDesign()
    }
    
    /*
     Link
     */
    func linkPopupViewDesign() {
        //        self.view.layoutIfNeeded()
        
//        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        window?.addSubview(linkPopupView)
        dimView = UIView()
        dimView.frame = UIScreen.main.bounds
        self.view.addSubview(dimView)
        dimView.backgroundColor = UIColor.black
        dimView.alpha = 0.6
        
        self.view.addSubview(linkPopupView)
        linkPopupView.isUserInteractionEnabled = true
        linkInsertBtn.isUserInteractionEnabled = true
        linkPopupView.layer.zPosition = 1
        
        linkPopupView.translatesAutoresizingMaskIntoConstraints = false
        
        linkPopupView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        linkPopupView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        linkPopupView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        linkPopupView.heightAnchor.constraint(equalToConstant: 307).isActive = true
        
        linkPopupView.isHidden = true
        dimView.isHidden = true
        
        // Window의 자식으로 놓으므로 직접 추가 해주어야함
        
        //        self.view.layoutIfNeeded()
    }
    
   
}

// MARK: - TextField & Keyboard

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
    
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let bottomSafeArea = window?.safeAreaInsets.bottom else {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            //            self.commentTextFieldView?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea!)
            //                        self.commentTableViewBottom.constant = self.commentTableViewBottom.constant + keyboardSize.height
            //            self.scrollView?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea!)
            
            self.linkPopupView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            self.bottomIconContainerView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea)
        }
    }
    
    @objc func moveDownTextView() {
        self.linkPopupView.transform = .identity
        self.bottomIconContainerView.transform = .identity
        //        self.commentTextFieldView?.transform = .identity
        //        self.scrollView?.transform = .identity
        //                self.commentTableViewBottom.constant = 0
    }
}

// MARK: - TagsTableView

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
        case 0:
            return matchedList.count
            
        case 1:
            return viewModel.uploadImagesRelay.value.count
            
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.tagLabel.text = matchedList[indexPath.row]
            return cell
            
        case 1:
            
            let imageArr = viewModel.uploadImagesRelay.value
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadImage", for: indexPath) as! ImageUploadCell
            
            cell.uploadImageView.image = imageArr[indexPath.row]
            
            guard let cellImage = cell.uploadImageView.image else {
                return UITableViewCell()
            }
        
            let scaledHeight = ((UIScreen.main.bounds.width - 40) * cellImage.size.height) / cellImage.size.width
            cell.heightConstraint.constant = scaledHeight
            
            print(scaledHeight)
            
            return cell

        default:
            break
        }
     
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        case 0:
            
            tagging.updateTaggedList(allText: tagging.textView.text, tagText: matchedList[indexPath.row])
            tableView.isHidden = true
            tableView.deselectRow(at: indexPath, animated: true)
            
            break
            
        case 1:
            break
        
        default:
            break
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch tableView.tag {
//        case 0:
//
//            return CGFloat(50)
//
//        case 1:
//
//            return UITableView.automaticDimension
//
//        default:
//            break
//        }
//        return UITableView.automaticDimension
//    }
}

// MARK: - ImagePicker

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            testImageView.image = image
            
            var imageArr: [UIImage] = viewModel.uploadImagesRelay.value
            imageArr.append(image)
            viewModel.uploadImagesRelay.accept(imageArr)
            
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
