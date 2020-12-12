//
//  ArticleDetailViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

import Kingfisher

import AVFoundation
import AVKit

import Lottie

import SwipeCellKit

import Toast_Swift

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet var informationTopContainer: UIView!
    @IBOutlet weak var informationTitle: UILabel!
    @IBOutlet var informationTags: [UILabel]! {
        didSet {
            for tag in informationTags {
                tag.text = ""
                tag.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var scrapIcon: UIButton! {
        didSet {
            scrapIcon.isHidden = true
            scrapIcon.layer.zPosition = 999
        }
    }
    @IBOutlet var scrapNavbarItem: UIBarButtonItem!
    @IBOutlet var scrapNavbarIcon: UIButton!
    @IBOutlet weak var scrapCountLabel: UILabel! {
        didSet {
            scrapCountLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var articleTopContainer: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleCategory: UILabel!
    @IBOutlet weak var articleTag: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var imageStackView: UIStackView!
    
    @IBOutlet weak var videoStackView: UIStackView!
    @IBOutlet weak var videoStackViewTop: NSLayoutConstraint!
    var avPlayer = AVPlayer()
    var avController = AVPlayerViewController()
    
    @IBOutlet weak var urlStackView: UIStackView!
    @IBOutlet weak var urlStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var urlStackLoadingView: UIView!
    
    @IBOutlet weak var userProfileTitleBtn: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var createdAt: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTableViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var commentTextFieldRoundView: TextFieldRound!
    @IBOutlet weak var commentTextFieldTopRoundView: UIView! {
        didSet {
            commentTextFieldTopRoundView.layer.cornerRadius = 24
            commentTextFieldTopRoundView.clipsToBounds = true
            commentTextFieldTopRoundView.layer.masksToBounds = true
            commentTextFieldTopRoundView.appShadow(.s20)
        }
    }
    @IBOutlet weak var commentTextFieldView: UIView! {
        didSet {
            //            commentTextFieldView.layer.cornerRadius = 24
            //            commentTextFieldView.clipsToBounds = true
            //            commentTextFieldView.layer.masksToBounds = false
            //            commentTextFieldView.appShadow(.s20)
        }
    }
    @IBOutlet weak var commentTextField: UITextField! {
        didSet {
            commentTextField.delegate = self
        }
    }
    @IBOutlet weak var commentProfile: UIImageView!
    @IBOutlet var commentProfileWidthConstraint: NSLayoutConstraint!
    @IBOutlet var commentProfileLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var commentProfileTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var plusBtn: UIButton!
    
    var disposeBag = DisposeBag()
    let viewModel = ArticleDetailViewModel()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideTransparentNavigationBar()
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray210)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize"){
            //            if let newvalue = change?[.newKey] {
            if (change?[.newKey]) != nil {
                let contentHeight: CGFloat = commentTableView.contentSize.height
                DispatchQueue.main.async {
                    self.commentTableViewHeight.constant = contentHeight
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        scrollView.delegate = self
        
        // 스크롤 크기 조절
        commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        Observable.combineLatest(
            viewModel.postUidRelay,
            viewModel.postKindRelay
        )
        .map{ $0 != "" && $1 != -1}
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] value in
            self?.viewDesign()
            self?.tablewViewSetting()
            self?.viewModel.dataSetting()
        })
        .disposed(by: disposeBag)
        
        viewModel.titleRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value != "" {
                    //                    self?.navigationItem.title = "\(value)"
                    self?.titleLabel.text = "\(value)"
                    self?.informationTitle.text = "\(value)"
                    self?.informationTitle.lineBreakStrategy = .hangulWordPriority
                }
            })
            .disposed(by: disposeBag)
        
        // 썸네일
        viewModel.thumbnailImageRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [weak self] url in
                self?.titleImg.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        // 본문 이미지
        viewModel.imagesRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] urls in
                // 가장 첫 번째 이미지를 썸네일로
                self?.imageStackViewSetting()
                
                
            })
            .disposed(by: disposeBag)
        
        viewModel.videosRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                
                // 하나도 없을 경우 오토레이아웃 삭제로 간격 조절
                if value.count == 0 {
                    self?.videoStackViewTop.constant = 0
                }
                else if value.count > 0 {
                    self?.videoStackViewTop.constant = 16
                    self?.videoStackViewSetting()
                }
            })
            .disposed(by: disposeBag)
        
        // 본문 적용
        viewModel.descriptionRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] desc in
                //                self?.textView.text = "\(desc)"
                if self?.viewModel.descriptionRelay.value != "" {
                    self?.textView.text = desc.replacingOccurrences(of: "\\n", with: "\n")
                    self?.adjustUITextViewHeight(arg: self!.textView)
                    self?.viewModel.descriptionLoading.accept(true)
                    print("글 로딩 완료")
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.tagsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                if tags.count <= 0 {
                    
                } else {
                    var tagString: String = ""
                    for (index, tag) in tags.enumerated() {
                        if self?.viewModel.postKindRelay.value == PostKinds.article.rawValue {
                            tagString += "#\(tag) "
                        } else if self?.viewModel.postKindRelay.value == PostKinds.information.rawValue {
                            self?.informationTags[index].text = "#\(tag)"
                            self?.informationTags[index].isHidden = false
                        }
                    }
                    
                    self?.articleTag.text = "\(tagString)"
                }
                
                
                if self?.viewModel.postKindRelay.value == PostKinds.information.rawValue {
                    self?.informationTagDesign()
                }
                
            })
            .disposed(by: disposeBag)
        
        
        //         URL Link
        viewModel.urlLinksRelay
            //            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value.count == 0 {
                    
                } else if self?.viewModel.postUidRelay.value != "" && self?.viewModel.loadingAnimationViewIsInstalled == false {
                    let height = self?.viewModel.urlLinksRelay.value.count
                    let cgFloatHeight: CGFloat = CGFloat(height! * 90)
                    let cgFloatSpacing: CGFloat = CGFloat((height! - 1) * 16)
                    self?.urlStackViewHeight.constant = cgFloatHeight + cgFloatSpacing
                    
                    let animationView = Lottie.AnimationView.init(name: "Loading2")
                    animationView.contentMode = .scaleAspectFill
                    animationView.backgroundBehavior = .pauseAndRestore
                    
                    animationView.translatesAutoresizingMaskIntoConstraints = false
                    self?.urlStackLoadingView.addSubview(animationView)
                    
                    animationView.centerYAnchor.constraint(equalTo: self!.urlStackLoadingView.centerYAnchor).isActive = true
                    animationView.centerXAnchor.constraint(equalTo: self!.urlStackLoadingView.centerXAnchor).isActive = true
                    
                    animationView.loopMode = .loop
                    animationView.play()
                    
                    
                    
                    
                    self?.viewModel.linkViewSetting()
                    self?.viewModel.loadingAnimationViewIsInstalled = true
                    
                    
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.linksDataRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] links in
                if links.count == 0 {
                    
                } else {
                    self?.urlStackViewHeight.isActive = false
                    self?.urlViewSetting()
                }
            })
            .disposed(by: disposeBag)
        
        /*
         유저 프로필 // 작성날짜
         */
        Observable.combineLatest(
            viewModel.userDptiRelay,
            viewModel.userNicknameRelay,
            viewModel.createdAtRelay
        )
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] type, nickname, createdAt in
            if type.count == 0 || nickname.count == 0 { return }
            
            // 타입에 의한 프로필 사진 설정
            let profileImage: UIImage = UIImage(named: "Profile_\(type)") ?? UIImage()
            self?.userProfileImageView.image = profileImage
            
            // 타입에 의한 프로필 컬러 및 닉네임 설정
            self?.userProfileTitleBtn.setTitle("\(nickname)", for: .normal)
            let color: UIColor = UIColor.dptiColor(type)
            self?.userProfileTitleBtn.setTitleColor(color, for: .normal)
            
            // 작성날짜 설정
            self?.createdAt.text = "\(createdAt)"
        })
        .disposed(by: disposeBag)
        
        
        /*
         댓글
         */
        viewModel.commentsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.commentCount.text = "댓글 \(value.count)개"
                if value.count > 0 {
                    self?.commentTableView.reloadData()
                    //                    print("size : \((self?.commentTableView.contentSize.height)!)")
                    self?.commentTableViewHeight.constant = (self?.commentTableView.contentSize.height)!
                }
            })
            .disposed(by: disposeBag)
        
        /*
         댓글 인풋 창
         */
        commentTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.commentInputRelay)
            .disposed(by: disposeBag)
        
        
        /*
         스크랩
         */
        viewModel.scrapCountRelay
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] count in
                self?.scrapCountLabel.text = "\(count)"
            })
            .disposed(by: disposeBag)
        
        viewModel.isScrapPost
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                // 이미 스크랩 했을 경우
                if flag == true {
                    //                    self?.scrapIcon.setImage(UIImage(named: "scrapPressedIcon"), for: .normal)
                    self?.scrapNavbarIcon?.setImage(UIImage(named: "scrapPressedIconGray"), for: .normal)
                    
                }
                // 스크랩 안했을 경우
                else {
                    //                    self?.scrapIcon.setImage(UIImage(named: "scrapIcon"), for: .normal)
                    self?.scrapNavbarIcon?.setImage(UIImage(named: "scrapIconGray"), for: .normal)
                }
                
            })
            .disposed(by: disposeBag)
        
        
        /*
         로딩
         */
        Observable.combineLatest(
            viewModel.descriptionLoading,
            viewModel.imagesLoading
        )
        .map { $0 && $1 }
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] flag in
            if flag == true {
                print("모든 로딩이 완료되었습니다.")
                //                self?.loadingContainerView.layer.zPosition = -1
//                self?.loadingContainerView.stopAnimation()
            } else {
                print("모두 로딩이 되지 않습니다.")
                //                self?.loadingContainerView.layer.zPosition = 999
//                self?.loadingContainerView.playAnimation()
            }
        })
        .disposed(by: disposeBag)
        
        /*
         Keyboard
         */
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LinkWebVC" {
            let destination = segue.destination as! LinkWebViewController
            guard let url: URL = (sender as? URL) else {
                return
            }
            destination.url.accept(url)
            
        }
    }
    
    // 댓글 작성 버튼 누를 경우에
    @IBAction func pressedSendCommentBtn(_ sender: Any) {
        viewModel.commentInput()
        commentTextField.text = "" // 텍스트 초기화
        self.viewModel.commentDepth = 0 // 일반 댓글 뎁스로 초기화
        self.commentProfileIshidden(isHidden: true) // 대댓글 프로필 삭제
        self.view.endEditing(true) // 키보드 내리기
        //        commentTableView.reloadData() // 데이터 리로드
    }
    
    // 스크랩 버튼 누를 경우
    @IBAction func pressedScrapBtn(_ sender: Any) {
        // DPTI를 진행하지 않았을 경우
        if viewModel.isAvailableInteraction() == false {
            view.endEditing(true)
            DptiPopupManager.dptiPopup(popupScreen: .document, vc: self)
            return
        }
        
        // 스크랩된 게시물이 아닐 경우에는, 스크랩 되었다고 얼ㄹ럿을 띄우고 스크랩
        if self.viewModel.isScrapPost.value == false {
            let alert = AlertController(title: "스크랩 되었습니다", message: "게시물은 프로필에서 확인할 수 있습니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertScrap"))
            let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.viewModel.pressedScrapBtn()
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        // 스크랩이 이미 된 게시물일 경우, 추가 얼럿 없이 취소
        else {
            self.viewModel.pressedScrapBtn()
        }
    }
    
    // 메뉴 버튼을 눌렀을 때 하단에 뜨는 actionSheet
    @IBAction func pressedMenuBtn(_ sender: Any) {
        // 기본 ActionSheet Alert
        
        // 포스트의 UID
        let postUid = self.viewModel.postUidRelay.value
        
        // 포스트 작성자 UID
        guard let postUserUid = self.viewModel.userUID else {
            return
        }
        self.reportAlert(reportType: .post, userUid: postUserUid, contentUid: postUid)
    }
    
    @IBAction func pressedScrapBtnInView(_ sender: Any) {
        print("안되냐?")
    }
    
    /*
     게시글 작성자 이름을 클릭했을 경우
     */
    @IBAction func pressedAuthorName(_ sender: Any) {
        print("작성자 프로필로 이동합니다.")
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        
        guard let selectedUserUID = viewModel.userUID else {
            return
            
        }
        profileVC.viewModel.profileSetting.accept(viewModel.userDptiRelay.value)
        profileVC.viewModel.userNickname = viewModel.userNicknameRelay.value
        profileVC.viewModel.profileUID.accept(selectedUserUID)
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
}

// MARK: - Scroll 할때 네비게이션 보이기 / 안보이기

extension ArticleDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        let scrollOffset = scrollView.contentOffset.y
        
        if viewModel.postKindRelay.value == PostKinds.article.rawValue {
            if scrollOffset > 210 {
                self.navigationController?.presentTransparentNavigationBar()
                self.navItem.title = "\(viewModel.titleRelay.value)"
                
            } else {
                self.navigationController?.hideTransparentNavigationBar()
                self.navItem.title = ""

                
                
            }
        } else if viewModel.postKindRelay.value == PostKinds.information.rawValue {
            if scrollOffset > 130 {
                self.navigationController?.presentTransparentNavigationBar()
                self.navItem.title = "\(viewModel.titleRelay.value)"
                
                // 밑으로 내렸을 때는 true로
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            } else {
                self.navigationController?.hideTransparentNavigationBar()
                self.navItem.title = ""
            }
        }
    }
}

// MARK:- UI/UX

extension ArticleDetailViewController {
    func viewDesign() {
        let postKind: Int = viewModel.postKindRelay.value
        
        // 아티클일 경우에 InformationTopContainer 숨기기
        if postKind == PostKinds.article.rawValue {
            informationTopContainer.isHidden = true
        }
        // 인포메이션일 경우에 Constraint 재설정 및 다시 보이도록
        else if postKind == PostKinds.information.rawValue {
            textViewTopConstraint.isActive = false
            
            self.contentView.addSubview(informationTopContainer)
            informationTopContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
            informationTopContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
            informationTopContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
            informationTopContainer.heightAnchor.constraint(equalToConstant: 240).isActive = true
            
            textView.topAnchor.constraint(equalTo: informationTopContainer.bottomAnchor, constant: 48).isActive = true
            textView.translatesAutoresizingMaskIntoConstraints = false
            informationTopContainer.layer.zPosition = -1
            
            articleTopContainer.isHidden = true
        }
        articleCategory.articleCategoryDesign()
        
        // 댓글답글용 프로필 숨기기
        commentProfileIshidden(isHidden: true)
        
        // 스크롤뷰 제스쳐 추가
        scrollviewAddTapGesture()
    }
    
    func informationTagDesign(){
        
        // 태그 내부 글자 수에 맞춰서 width, height 재설정
        for tag in self.informationTags {
            let widthWithLabel: CGFloat = tag.intrinsicContentSize.width + 10
            
            let width: CGFloat = widthWithLabel
            let height: Int = 20
            
            // 위에서 #을 포함해서 자동으로 할당하므로 1
            if tag.text?.count == 1 {
                
                tag.widthAnchor.constraint(equalToConstant: 0).isActive = true
                tag.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                break
            }
            
            tag.translatesAutoresizingMaskIntoConstraints = false
            tag.widthAnchor.constraint(equalToConstant: width).isActive = true
            tag.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            
            tag.layer.masksToBounds = true
            tag.layer.cornerRadius = 10
        }
    }
    
    // 내용 본문에 Height에 맞게 조절하기 위해
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func scrollviewAddTapGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        print("touchSCrollview")
        self.view.endEditing(true)
        
        self.commentProfileIshidden(isHidden: true)
        self.viewModel.commentDepth = 0 // 일반 댓글 뎁스로 변경
    }
}

// MARK: - UploadImage

extension ArticleDetailViewController {
    
    func imageStackViewSetting() {
        /*
         이미지가 없을 경우
         */
        if viewModel.imagesRelay.value.count == 0 {
            print("이미지의 개수가 0개이므로 로딩을 완료합니다.")
            viewModel.imagesLoading.accept(true)
            return
        }
        
        /*
         이미지가 있을 경우
         */
        for (index, imageURL) in viewModel.imagesRelay.value.enumerated() {
            print("index처음에 : \(index)")
            let imageView = UIImageView()
            
            imageStackView.insertArrangedSubview(imageView, at: index)
            imageView.kf.indicatorType = .activity
            
            imageView.kf.setImage(with: imageURL,
                                  progressBlock: {receivedSize, totalSize in
                                    print("\(index) : \(receivedSize), \(totalSize)")
                                  },
                                  completionHandler:  { [weak self] result in
                                    switch result {
                                    case .success(let value):
                                        print(value.image)
                                        guard let image = value.image.resize(withWidth: UIScreen.main.bounds.width) else {
                                            return
                                        }
                                        
                                        let scaledHeight = ((UIScreen.main.bounds.width - 40) * image.size.height) / image.size.width
                                        
                                        imageView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
                                        imageView.trailingAnchor.constraint(equalTo: self!.contentView.trailingAnchor, constant: -20).isActive = true
                                        imageView.leadingAnchor.constraint(equalTo: self!.contentView.leadingAnchor, constant: 20).isActive = true
                                        imageView.layer.cornerRadius = 12
                                        imageView.layer.masksToBounds = true
                                        
                                        // 첨부된 이미지 우하단에 있는 아이콘
                                        let iconView = UIImageView()
                                        iconView.image = UIImage(named: "uploadImageIcon") ?? UIImage()
                                        imageView.addSubview(iconView)
                                        iconView.widthAnchor.constraint(equalToConstant: 18).isActive = true
                                        iconView.heightAnchor.constraint(equalToConstant: 18).isActive = true
                                        
                                        iconView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true
                                        iconView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16).isActive = true
                                        iconView.translatesAutoresizingMaskIntoConstraints = false
                                        iconView.layer.zPosition = 2
                                        
                                        
                                        //                                        print(value.cacheType)
                                        //                                        print(value.source)
                                        
                                        if index == (self!.viewModel.imagesRelay.value.count - 1) {
                                            print("\(index + 1)가지 이미지 로딩을 완료했습니다")
                                            self?.viewModel.imagesLoading.accept(true)
                                        }
                                        
                                    case .failure(let error):
                                        print(error)
                                    }
                                  })
            imageStackView.layoutIfNeeded()
            imageStackView.sizeToFit()
        }
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Video

extension ArticleDetailViewController {
    func videoStackViewSetting() {
        for (index, videoURL) in viewModel.videosRelay.value.enumerated() {
            guard let videoURL = videoURL else {
                return
            }
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            // 인덱스 순서에 맞춰서 이미지가 들어가도록
            videoStackView.insertArrangedSubview(imageView, at: index)
            
            // width사이즈에 맞게 무조건 16:9 사이즈로 고정되도록
            let scaledHeight = (UIScreen.main.bounds.width - 40) / 16 * 9
            
            // Autolayout
            imageView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            
            // Design
            imageView.layer.cornerRadius = 12
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            let playIconImageView: UIImageView = UIImageView.init(image: UIImage(named: "playIcon"))
            imageView.addSubview(playIconImageView)
            playIconImageView.translatesAutoresizingMaskIntoConstraints = false
            playIconImageView.widthAnchor.constraint(equalToConstant: playIconImageView.image!.size.width).isActive = true
            playIconImageView.heightAnchor.constraint(equalToConstant: playIconImageView.image!.size.height).isActive = true
            playIconImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            playIconImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            
            
            
            // 이미지를 클릭했을 경우에 영상이 뜨도록
            let singleTap = URLSenderTapGestureRecognizer(target: self, action: #selector(tapDetected(avUrl:)))
            singleTap.url = videoURL
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(singleTap)
            
            print("VideoScaledHeight :  \(scaledHeight)")
            AVAsset(url: videoURL).generateThumbnail(completion: { image in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    imageView.image = image
                    //                self?.videoTestImageView.kf.setImage(with: image)
                }
            })
        }
        
        
        
    }
    
    
    @objc func tapDetected(avUrl: URLSenderTapGestureRecognizer) {
        // Your action
        guard let url = avUrl.url else {
            return
        }
        
        // 이미지가 URL을 가지고 있다면 클릭했을 때 띄우도록
        self.avPlayer = AVPlayer(url: url)
        avController.player = avPlayer
        avController.view.frame = self.view.frame
        self.present(avController, animated: true, completion: nil)
        avPlayer.play()
    }
    
    func imagePreview(from moviePath: URL, in seconds: Double) -> UIImage? {
        let timestamp = CMTime(seconds: seconds, preferredTimescale: 60)
        let asset = AVURLAsset(url: moviePath)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        guard let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) else {
            return nil
        }
        return UIImage(cgImage: imageRef)
    }
    
    
}

class URLSenderTapGestureRecognizer: UITapGestureRecognizer {
    var url: URL?
}

extension AVAsset {
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

// MARK: - URL

extension ArticleDetailViewController {
    
    
    func urlViewSetting() {
        urlStackLoadingView.removeFromSuperview()
        
        for linkData in viewModel.linksDataRelay.value {
            let containerView: UIView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.layer.borderWidth = 1.5
            containerView.layer.borderColor = UIColor.appColor(.white235).cgColor
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
            containerView.backgroundColor = .clear
            
            urlStackView.addArrangedSubview(containerView)
            
            // 이미지를 클릭했을 경우에 영상이 뜨도록
            let singleTap = LinkURLSenderTapGestureRecognizer(target: self, action: #selector(linkContainerViewtapDetected(url:)))
            singleTap.url = linkData.url
            containerView.isUserInteractionEnabled = true
            containerView.addGestureRecognizer(singleTap)
            
            containerView.leadingAnchor.constraint(equalTo: urlStackView.leadingAnchor, constant: 0).isActive = true
            containerView.trailingAnchor.constraint(equalTo: urlStackView.trailingAnchor, constant: 0).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            
            let imageView: UIImageView = UIImageView()
            //        let stringImageURL = URL(string: viewModel.linksDataRelay.value[0].image)
            
            // 이미지가 없을 경우
            if linkData.image == "" {
                imageView.image = UIImage(named: "linkImage")
            } else {
                imageView.kf.setImage(with: URL(string: "\(linkData.image)"))
            }
            
            containerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            imageView.layer.cornerRadius = 4
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.zPosition = 2
            
            
            let title: UILabel = UILabel()
            containerView.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24).isActive = true
            title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
            title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
            title.numberOfLines = 2
            title.layer.zPosition = 2
            
            let text: String = "\(linkData.title)"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo Regular", size: 12) as Any,
                .foregroundColor : UIColor.appColor(.textSmall),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            title.attributedText = attributedString
            
            let urlString: UILabel = UILabel()
            containerView.addSubview(urlString)
            urlString.translatesAutoresizingMaskIntoConstraints = false
            urlString.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24).isActive = true
            urlString.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
            urlString.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
            urlString.numberOfLines = 1
            urlString.layer.zPosition = 2
            let urlStringText: String = "\(linkData.url)"
            let urlStringeAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "SFProDisplay-Regular", size: 12) as Any,
                .foregroundColor : UIColor.appColor(.gray170),
            ]
            let urlAttributedString = NSAttributedString(string: urlStringText, attributes: urlStringeAttributes)
            urlString.attributedText = urlAttributedString
            
            urlStackView.layoutIfNeeded()
            urlStackView.translatesAutoresizingMaskIntoConstraints = false
            urlStackView.sizeToFit()
        }
    }
    
    @objc func linkContainerViewtapDetected(url: LinkURLSenderTapGestureRecognizer) {
        // Your action
        guard let url = url.url else {
            return
        }
        
        performSegue(withIdentifier: "LinkWebVC", sender: url)
        
        print(url)
        
        //
        //        // 이미지가 URL을 가지고 있다면 클릭했을 때 띄우도록
        //        self.avPlayer = AVPlayer(url: url)
        //        avController.player = avPlayer
        //        avController.view.frame = self.view.frame
        //        self.present(avController, animated: true, completion: nil)
        //        avPlayer.play()
    }
}

struct PreviewResponse {
    let url: URL // URL
    let title: String // title
    let image: String // main image
    let icon: String // favicon
    
    init(url: URL, title: String, image: String, icon: String) {
        self.url = url
        self.title = title
        self.image = image
        self.icon = icon
    }
}

class LinkURLSenderTapGestureRecognizer: UITapGestureRecognizer {
    var url: URL?
}


// MARK: - Comment

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource, CommentCellDelegate, SwipeTableViewCellDelegate {
    
    // Swipe 했을때 액션
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! CommentCell
        guard let commentCellUserUId = cell.userId else {
            return nil
        }
        
        // 신고가 10회 이상 누적되었으면 스와이프 불가능
        guard let reportCount = viewModel.commentsRelay.value[indexPath.row].report else {
            return nil
        }
        if reportCount >= 10 {
            return nil
        }
        
        // 코멘트의 유저 ID가 세팅되지 않았으면 스와이프 작동하지 않음
        // ex) 차단 및 신고당한 유저
        if commentCellUserUId == "" {
            return nil
        }
        
        var deleteAction: SwipeAction?
        // 내가 작성한 댓글일 경우에는 Delete셀만
        // TODO : Delete 로직 제작할 것
        if commentCellUserUId == viewModel.myUID {
            return nil
            deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
                // handle action by updating model with deletion
                print("댓글을 삭제합니다. : \(indexPath.row)")
                
            }
            deleteAction?.image = UIImage(named: "delete_icon")
        } else {
            deleteAction = SwipeAction(style: .destructive, title: "report") { action, indexPath in
                // handle action by updating model with deletion
                print("댓글을 신고합니다. : \(indexPath.row)")
                
                // 댓글 작성자 UID
                guard let commentUserUid: String = cell.userId else {
                    return
                }
                
                var targetBoard: TargetBoard = self.viewModel.targetBoard
                
                // 코멘트 Doc Uid
                guard let commentUid: String = cell.uid else {
                    return
                }
                
                guard let userProfile: UIImage = cell.commentProfile.image else {
                    return
                }
                
                guard let userNickname: String = cell.commentNickname.text else {
                    return
                }
                
                guard let commentText: String = cell.commentDescription.text else {
                    return
                }
                
                guard let commentCreatedAt: String = cell.commentDate.text else {
                    return
                }
                
                
                
                ReportManager.gotoReportScreen(reportType: .comment,
                                               vc: self,
                                               profileImage: userProfile,
                                               nickname: userNickname,
                                               text: commentText,
                                               createAt: commentCreatedAt,
                                               userUid: commentUserUid,
                                               contentUid: commentUid,
                                               targetBoard: targetBoard)

            }
            deleteAction?.image = UIImage(named: "report_icon")
        }
        
        
        return [deleteAction!]
    }
    
    func pressedHeartBtn(commentId: String, indexPathRow: Int) {
        // DPTI를 진행하지 않았을 경우
        if viewModel.isAvailableInteraction() == false {
            DptiPopupManager.dptiPopup(popupScreen: .document, vc: self)
            return
        }
        
        viewModel.pressedCommentHeart(uid: commentId)
        
        //        let indexPath = IndexPath(item: indexPathRow, section: 0)
        //        commentTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // CommentCellDelegate
    func pressedCommentReply(type: String) {
        commentProfileIshidden(isHidden: false)
        commentProfile.image = UIImage(named: "Profile_\(type)")
        
        if commentTextField.canBecomeFirstResponder {
            commentTextField.becomeFirstResponder()
        }
        
    }
    
    var textFieldReadingAnchor: NSLayoutConstraint {
        return commentTextFieldRoundView.leadingAnchor.constraint(equalTo: plusBtn.trailingAnchor, constant: 15)
    }
    
    
    func tablewViewSetting() {
        // Row Height를 무시하고, 각 Row 안의 내용에 따라 Row 높이가 유동적으로 결정 되도록
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 100
        commentTableView.separatorStyle = .none
        
        //        commentTableView.invalidateIntrinsicContentSize()
        //        commentTableView.layoutIfNeeded()
    }
    
    func commentProfileIshidden(isHidden: Bool) {
        // 이미 예정되어 있던 애니메이션은 모두 처리
        //        self.view.layoutIfNeeded()
        
        switch isHidden {
        case false:
            print("false")
            
            commentProfileTrailingConstraint.constant = 15
            commentProfileLeadingConstraint.constant = 15
            commentProfileWidthConstraint.constant = 40
            //            commentProfile.isHidden = false
            
            break
            
        case true:
            print("true")
            commentProfileLeadingConstraint.constant = 0
            commentProfileTrailingConstraint.constant = 15
            commentProfileWidthConstraint.constant = 0
            //            commentProfile.isHidden = true
            
            break
        }
        
        //        UIView.animate(withDuration: 0.5) { [self] in
        //            self.view.layoutIfNeeded()
        //        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commentsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.delegate = self
        cell.commentDelegate = self
        
        let cellIndex: Int = indexPath.row
        let model: Comment = viewModel.commentsRelay.value[cellIndex]
        
        if let depth = viewModel.commentsRelay.value[indexPath.row].depth {
            //            print("댓글의 뎁스 : \(depth)")
            // 기본 댓글
            switch depth {
            case 0:
                cell.commentProfileLeadingConstraint.constant = 24
                break
            // 대댓글
            case 1:
                cell.commentProfileLeadingConstraint.constant = 80
                break
                
            default:
                break
            }
        }
        
        // 기본적으로 하트 아이콘으로 변경한 뒤에
        cell.selectedHeart = false
        cell.commentHeartBtn.setImage(UIImage(named: "heartIcon"), for: .normal)
        
        
        // 이미 유저가 하트를 누른 경우 이미지 변경
        for uid in viewModel.commentUserHeartUidArr {
            // 내가 적은 댓글일 경우에는 하트 추가
            if model.commentId == uid {
                //                print("UID가 같으므로 하트이미지를 변경합니다.")
                cell.selectedHeart = true
                cell.commentHeartBtn.setImage(UIImage(named: "heartIconPressed"), for: .normal)
            }
        }
        
        
        if let userType: String = model.userDpti {
            cell.commentProfile.image = UIImage(named: "Profile_\(userType)")
            cell.commentNickname.textColor = UIColor.dptiColor(userType)
            cell.dptiType = userType
        }
        
        // 글 작성자와 댓글 작성자가 같은 경우 저자 표시
        if viewModel.userUID == model.userId {
            cell.commentAuthor.isHidden = false
        }
        
        
        cell.commentDescription.text = model.comment
        cell.commentNickname.text = model.nickname
        cell.commentDate.text = model.createdAt
        if let heartCount = model.heartCount {
            cell.commentHeart.text = "\(heartCount)"
        }
        cell.indexpathRow = cellIndex
        cell.uid = model.commentId
        cell.userId = model.userId
        cell.viewModel = self.viewModel
        
        // 유저 DPTI 진행 유무에 따라서 하트 버튼 등이 안눌리게 하기 위해서
        cell.isInteractionEnabledDPTI = viewModel.isAvailableInteraction()
        
        // 신고 누적 횟수 10회 이상일 경우 하트 버튼 숨김
        guard let reportCount = model.report else { return cell }
        if reportCount >= 10 {
            cell.hideHeartBtn()
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

// MARK: - Keyboard & Touch

extension ArticleDetailViewController: UITextFieldDelegate {
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        let window = UIApplication.shared.keyWindow
        guard let bottomSafeArea = window?.safeAreaInsets.bottom else {
            return
        }

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 한번 초기화를 하고 나서
            self.commentTextFieldView?.transform = .identity
            self.commentTableViewBottom.constant = 0
            
            self.commentTextFieldView?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea)
            self.commentTableViewBottom.constant = self.commentTableViewBottom.constant + keyboardSize.height - bottomSafeArea
        }
    }

    @objc func moveDownTextView() {
        self.commentTextFieldView?.transform = .identity
        self.commentTableViewBottom.constant = 0
    }

    // 텍스트필드 수정이 시작될때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // DPTI를 진행하지 않았을 경우
        if viewModel.isAvailableInteraction() == false {
            view.endEditing(true)
            DptiPopupManager.dptiPopup(popupScreen: .document, vc: self)
            return
        }
    }
}



// MARK: - Report

extension ArticleDetailViewController {
    // 게시물 신고 및 댓글 신고를 누를 경우 뜨는 기본 ActionSheet
    func reportAlert(reportType: ReportType, userUid: String, contentUid: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 신고하기
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { (action) in
            // observe it in the buttons block, what button has been pressed
            print("didPress report abuse")
            
            guard let profileImage: UIImage = self.userProfileImageView.image,
                  let nickname: String = self.userProfileTitleBtn.titleLabel?.text,
                  let title: String = self.titleLabel.text else {
                return
            }
            
            let targetBoard: TargetBoard = self.viewModel.targetBoard
            
            ReportManager.gotoReportScreen(reportType: .post,
                                           vc: self,
                                           profileImage: profileImage,
                                           nickname: nickname,
                                           text: title,
                                           createAt: "",
                                           userUid: userUid,
                                           contentUid: contentUid,
                                           targetBoard: targetBoard)
        }
        
        actionSheet.addAction(reportAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            print("didPress cancel")
        }
        actionSheet.addAction(cancelAction)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
