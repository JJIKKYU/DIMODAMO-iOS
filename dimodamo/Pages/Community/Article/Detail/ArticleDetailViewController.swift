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

class ArticleTopContainerView: UIView {
    
}

class ArticleDetailViewController: UIViewController {
    @IBOutlet var informationTopContainer: UIView!
    @IBOutlet weak var informationTitle: UILabel!
    @IBOutlet var informationTags: [UILabel]!
    
    @IBOutlet weak var articleTopContainer: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var articleCategory: UILabel!
    
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
    @IBOutlet weak var commentTextFieldView: TextFieldContainerView!
    @IBOutlet weak var commentTextField: UITextField!
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
        
//        navigationController?.invisible()
        self.navigationController?.hideTransparentNavigationBar()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
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
                if self?.viewModel.imagesRelay.value.count ?? 0 > 0 {
                    self?.imageStackViewSetting()
                }
                
                
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
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.tagsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                if tags.count <= 0 {
                    
                } else {
                    for (index, tag) in tags.enumerated() {
                        self?.tags[index].text = "#\(tag)"
                    }
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
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //            self.commentTableView.reloadData()
        //            }
        
        /*
         댓글 인풋 창
         */
        commentTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel.commentInputRelay)
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
            guard let url: URL = (sender as! URL) else {
                return
            }
            destination.url.accept(url)
            
        }
    }
    
    @IBAction func pressedSendCommentBtn(_ sender: Any) {
        viewModel.commentInput()
        commentTextField.text = ""
        commentTableView.reloadData()
    }
    
    
    
}

extension UINavigationController {

    public func presentTransparentNavigationBar() {
        view.layer.layoutIfNeeded()
        setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.3) { [self] in
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.textSmall)]
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .white
            view.layer.layoutIfNeeded()
        }
        
    }

    public func hideTransparentNavigationBar() {
        view.layer.layoutIfNeeded()
        setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.3) { [self] in
//            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            navigationBar.barTintColor = .white
            view.layer.layoutIfNeeded()
        }
        
        
    }
}

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
            if scrollOffset > 140 {
                self.navigationController?.presentTransparentNavigationBar()
                self.navItem.title = "\(viewModel.titleRelay.value)"
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
            
            articleTopContainer.isHidden = true
            informationTagDesign()
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
            let width: Int = (Int(tag.text!.count) * 10) + 20
            let height: Int = 20
            tag.translatesAutoresizingMaskIntoConstraints = false
            tag.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
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
    }
}

// MARK: - UploadImage

extension ArticleDetailViewController {
    
    func imageStackViewSetting() {
        for (index, imageURL) in viewModel.imagesRelay.value.enumerated() {
            let imageView = UIImageView()
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageURL,
                                  options: [ .transition(.fade(2))],
                                  completionHandler:  { [self] result in
                                    switch result {
                                    case .success(let value):
                                        print(value.image)
                                        
                                        let image = value.image
                                        
                                        let scaledHeight = ((UIScreen.main.bounds.width - 40) * image.size.height) / image.size.width
                                        //                                        print("scaleHeight : \(scaledHeight)")
                                        
                                        imageStackView.insertArrangedSubview(imageView, at: index)
                                        
                                        imageView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
                                        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
                                        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
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
                                        
                                        
                                        print(value.cacheType)
                                        print(value.source)
                                        
                                    case .failure(let error):
                                        print(error)
                                    }
                                  })
            imageStackView.layoutIfNeeded()
        }
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.sizeToFit()
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
                imageView.image = UIImage(named: "urlDefaultImage")
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

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource, CommentCellDelegate {
    func pressedHeartBtn(commentId: String, indexPathRow: Int) {
        viewModel.pressedCommentHeart(uid: commentId)
        
//        let indexPath = IndexPath(item: indexPathRow, section: 0)
//        commentTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // CommentCellDelegate
    func pressedCommentReply(type: String) {
        print("hello")
        commentProfileIshidden(isHidden: false)
        commentProfile.image = UIImage(named: "Profile_\(type)")
        commentTextField.becomeFirstResponder()
    }
    
    var textFieldReadingAnchor: NSLayoutConstraint {
        return commentTextFieldRoundView.leadingAnchor.constraint(equalTo: plusBtn.trailingAnchor, constant: 15)
    }
    
    
    func tablewViewSetting() {
        // Row Height를 무시하고, 각 Row 안의 내용에 따라 Row 높이가 유동적으로 결정 되도록
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 100
        //        commentTableView.invalidateIntrinsicContentSize()
        //        commentTableView.layoutIfNeeded()
    }
    
    func commentProfileIshidden(isHidden: Bool) {
        // 이미 예정되어 있던 애니메이션은 모두 처리
        self.view.layoutIfNeeded()
        
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
        
        UIView.animate(withDuration: 0.5) { [self] in
            self.view.layoutIfNeeded()
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commentsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let cellIndex: Int = indexPath.row
        let model: Comment = viewModel.commentsRelay.value[cellIndex]
        
        if let depth = viewModel.commentsRelay.value[indexPath.row].depth {
            print("댓글의 뎁스 : \(depth)")
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
        
        
        // 이미 유저가 하트를 누른 경우 이미지 변경
        for uid in viewModel.commentUserHeartUidArr {
            if model.commentId == uid {
                print("UID가 같으므로 하트이미지를 변경합니다.")
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
        cell.viewModel = self.viewModel
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
//        guard let indexPath = tableView.indexPathForSelectedRow else {
//            return
//        }
//        let currentCell = tableView.cellForRow(at: indexPath) as! CommentCell

//        self.view.endEditing(true)
        print("\(indexPath.row)")
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

//MARK:: - Keyboard & Touch

extension ArticleDetailViewController: UITextFieldDelegate {
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        let window = UIApplication.shared.keyWindow
        let bottomSafeArea = window?.safeAreaInsets.bottom
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.commentTextFieldView?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea!)
//                        self.commentTableViewBottom.constant = self.commentTableViewBottom.constant + keyboardSize.height
            //            self.scrollView?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + bottomSafeArea!)
        }
    }
    
    @objc func moveDownTextView() {
        self.commentTextFieldView?.transform = .identity
        //        self.scrollView?.transform = .identity
//                self.commentTableViewBottom.constant = 0
    }
    
    // 터치했을때 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
        self.view.endEditing(true)
    }
}
