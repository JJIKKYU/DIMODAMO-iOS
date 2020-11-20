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

import Kingfisher

import BottomPopup

class CreatePostViewController: UIViewController, TaggingDataSource {
    
    @IBOutlet weak var descriptionContainer: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLimit: UILabel!
    
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var tagsLimit: UILabel!
    
    @IBOutlet var postLoadingView: LottieLoadingView2! {
        didSet {
            postLoadingView.isHidden = true
            postLoadingView.stopAnimation()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            postLoadingView.addSubview(blurEffectView)
            
            self.navigationController?.view.addSubview(postLoadingView)
            postLoadingView.frame = UIScreen.main.bounds
            
            
        }
    }
    var lottieLoadingView: LottieLoadingView2! {
        didSet {
            lottieLoadingView.isHidden = false
            
            
        }
    }
    
    @IBOutlet weak var mainTableContentView: UIView!
    @IBOutlet weak var mainTableViewEmptyImage: UIImageView!
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.rowHeight = UITableView.automaticDimension
            mainTableView.estimatedRowHeight = 100
        }
    }
    
    /*
     Link
     */
    
    @IBOutlet weak var linkLoadingView: LottieLoadingView! {
        didSet {
            linkLoadingView.stopAnimation()
        }
    }
    
    /*
     UploadImage
     */
    var imagePicker : UIImagePickerController = UIImagePickerController()
    
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
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.text = "내용을 입력해 주세요"
            descriptionTextView.textColor = UIColor.appColor(.gray210)
        }
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.presentTransparentNavigationBar()
    }
    
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
        
        descriptionTextView.delegate = self
        
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
            })
            .disposed(by: disposeBag)
        
        /*
         이미지 업로드
         */
//        viewModel.uploadImagesRelay
//            .subscribeOn(MainScheduler.instance)
//            .subscribe(onNext : { [weak self] _ in
//                self?.mainTableView.reloadData()
//                self?.view.layoutIfNeeded()
//            })
//            .disposed(by: disposeBag)
        
        
        /*
         링크 업로드
         */
        // LinkPopupView에서 주소 및 이미지 체크
        viewModel.uploadLinkDataRelay
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let data = data else {
                    return
                }
                self?.linkLoadingView.stopAnimation()
                
                let imageUrl = URL(string: data.image)
                let title = data.title
                let url = data.url
                
                // 썸네일 이미지가 없다면
                if data.image == "" {
//                    self?.linkPopupView.thumbImageView.image = UIImage(named: "linkImage")
                }
                // 썸네일 이미지가 있다면
                else {
//                    self?.linkPopupView.thumbImageView.kf.setImage(with: imageUrl)
                }
                
//                self?.linkPopupView.titleLabel.text = "\(title)"
//                self?.linkPopupView.addressLabel.text = "\(url)"
            })
            .disposed(by: disposeBag)

        
        /*
         기본 Empty이미지 삭제 및 데이터가 들어올 때마다 테이블 리로드
         */
        Observable.combineLatest(
            viewModel.uploadImagesRelay,
            viewModel.uploadLinksDataRelay
        )
        .map { $0.count > 0 || $1.count > 0}
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] flag in
            // 업로드를 처음 할 때
            if flag == true && self!.mainTableViewEmptyImage.isHidden == false {
                self?.mainTableViewEmptyImage.isHidden = true
                self?.mainTableView.tableHeaderView?.frame.size = CGSize(width: self!.mainTableView.frame.width, height: CGFloat(585))
                self?.view.layoutIfNeeded()
            }
            
            self?.mainTableView.reloadData()
            self?.view.layoutIfNeeded()
        })
        .disposed(by: disposeBag)
        
        /*
         로딩
         */
        viewModel.sendPostLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                // 업로드 중일 경우에는 로딩 창 띄우기
                if flag == true {
                    self?.postLoadingView.playAnimation()
                }
                // 업로드 중이 아닐 경우에는 로딩 창 삭제
                else if flag == false {
                    self?.postLoadingView.stopAnimation()
                    self?.dismiss(animated: true, completion: nil)
                }
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
    
    /*
     글 작성 완료
     */
    @IBAction func pressedCompleteBtn(_ sender: Any) {
        // 타이틀이 작성되지 않았을 경우
        if viewModel.titleIsValid == false {
            
        }
        // 내용이 작성되지 않았을 경우
        else if viewModel.descriptionIsValid == false {
            
        }
        // 글이 모두 다 작성되었을 경우
        else if viewModel.titleIsValid == true && viewModel.descriptionIsValid == true {
            viewModel.upload()
        }
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
     이미지 업로드 테스트
     */
    
    @IBAction func testBtn(_ sender: Any) {
//        self.viewModel.uploadImage(documentID: "ABCD", completion: nil)
    }
    
    
    /*
     Link
     */
    
    @IBAction func pressedLinkBtn(_ sender: Any) {
        print("링크삽입")
//        self.linkTextField.becomeFirstResponder()
        
        let storyboard = UIStoryboard(name: "Community", bundle: nil)

        guard let popupVC = storyboard.instantiateViewController(withIdentifier: "LinkPopupVC") as? LinkPopupVC else { return }
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = true
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func pressedLinkPopupViewCloseBtn(_ sender: Any) {
        hideLinkPopupView()
        self.viewModel.uploadLinkDataRelayReset()
    }
    
    @IBAction func pressedLinkCheck(_ sender: Any) {
        print("링크를 체크합니다")
        
//        guard let link = self.linkTextField.text else {
//            return
//        }
//        self.linkLoadingView.playAnimation()
//
//        self.viewModel.linkCheck(url: link)
    }
    
    @IBAction func pressedLinkInsertBtn(_ sender: Any) {
        print("링크를 삽입합니다")
        
        viewModel.linkViewSetting()
        hideLinkPopupView()
    }
    
    func hideLinkPopupView() {
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.backgroundColor = .white
//        navigationController?.presentTransparentNavigationBar()
//        self.linkPopupView.isHidden = true
//        self.linkPopupView.dataReset()
//        self.dimView.isHidden = true
//        self.linkTextField.resignFirstResponder()
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

// MARK: - TextField & Keyboard

extension CreatePostViewController: UITextFieldDelegate, UITextViewDelegate {
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
            
//            self.linkPopupView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            self.bottomIconContainerView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea)
        }
    }
    
    @objc func moveDownTextView() {
//        self.linkPopupView.transform = .identity
        self.bottomIconContainerView.transform = .identity
        //        self.commentTextFieldView?.transform = .identity
        //        self.scrollView?.transform = .identity
        //                self.commentTableViewBottom.constant = 0
    }
    
    
    // TextView (메인) placehorder logic
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(.gray210) {
            textView.text = nil
            textView.textColor = UIColor.appColor(.gray170)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해 주세요"
            textView.textColor = UIColor.appColor(.gray210)
        }
    }
}

// MARK: - TagsTableView

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource, DeleteUploadCellDelegate {
    
    // 업로드 된 이미지에서 삭제 버튼을 눌렀을 경우
    func deleteCell(tagIndex: Int, Kinds: UploadCellKinds) {
        print("이미지를 삭제합니다")
        
        switch Kinds {
        case .image:
            viewModel.deleteImage(tagIndex: tagIndex)
            break
            
        case .link:
            viewModel.deleteLink(tagIndex: tagIndex)
            break
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
        case 0:
            return matchedList.count
            
        case 1:
            return viewModel.uploadImagesRelay.value.count + viewModel.uploadLinksDataRelay.value.count
            
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
            let linkArr = viewModel.uploadLinksDataRelay.value
            
            
            if (indexPath.row + 1) <= (imageArr.count) {
                print("imageArr.Count == indexpath.row")
                let index = indexPath.row
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "UploadImage", for: indexPath) as! ImageUploadCell
                
                cell.uploadImageView.image = imageArr[index].resize(withWidth: UIScreen.main.bounds.width)
                
                // 이미지 삭제 버튼을 눌렀을 경우 삭제할 수 있도록 델리게이트 설정
                cell.deleteUploadImageDelegate = self
                cell.tagIndex = index
                
                guard let cellImage = cell.uploadImageView.image else {
                    return UITableViewCell()
                }
            
                let scaledHeight = ((UIScreen.main.bounds.width - 40) * cellImage.size.height) / cellImage.size.width
                cell.heightConstraint.constant = scaledHeight
                
                print(scaledHeight)
                
                return cell
            }
            else if (indexPath.row + 1) <= imageArr.count + linkArr.count {
                let index = indexPath.row - imageArr.count
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "UploadLink", for: indexPath) as! LinkUploadCell
                
                
                if let imageUrl: URL = URL(string: linkArr[index].image) {
                    cell.thumbImageView.kf.setImage(with: imageUrl)
                } else {
                    cell.thumbImageView.image = UIImage(named: "linkImage")
                }
                
                cell.deleteCellDelegate = self
                cell.tagIndex = index
                
                cell.titleLabel.text = "\(linkArr[index].title)"
                
                cell.urlLabel.text = "\(linkArr[index].url)"
                
                return cell
            }
            
            
            

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
            
            var imageArr: [UIImage] = viewModel.uploadImagesRelay.value
            imageArr.append(image)
            viewModel.uploadImagesRelay.accept(imageArr)
            
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Bottom Pupup VC

extension CreatePostViewController: BottomPopupDelegate {
    
}
