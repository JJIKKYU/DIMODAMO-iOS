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

class ArticleDetailViewController: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var articleCategory: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var imageStackView: UIStackView!
    
    @IBOutlet weak var videoStackView: UIStackView!
    var avPlayer = AVPlayer()
    var avController = AVPlayerViewController()
    
    @IBOutlet weak var urlStackView: UIStackView!
    
    var imageView1: UIImageView = UIImageView()
    
    var article: Article?
    var disposeBag = DisposeBag()
    let viewModel = ArticleDetailViewModel()
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.invisible()
        //        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
        
        // 하단 탭바 숨기기
        //        (self.tabBarController as? TabBarViewController)?.invisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        scrollView.layoutIfNeeded()
        //        scrollView.isScrollEnabled = true
        //        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height)
    
        
        viewDesign()
        
        imageStackViewSetting()
        videoStackViewSetting()
        
        
        
        
        
        
        viewModel.titleRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.navigationItem.title = "\(value)"
                self?.titleLabel.text = "\(value)"
            })
            .disposed(by: disposeBag)
        
        viewModel.imageRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                
                //                self?.titleImg.image = UIImage(data: data)
                //                let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/test%2F0XgA8G0aM2FjkVaQ4aE4.png?alt=media&token=c6ddc035-77f5-4f30-9531-4734c167a7a6")
                self?.titleImg.kf.setImage(with: url)
                
            })
            .disposed(by: disposeBag)
        
        // 본문 적용
        viewModel.descriptionRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] desc in
                self?.textView.text = "\(desc)"
            })
            .disposed(by: disposeBag)
        
        viewModel.tagsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                for (index, tag) in tags.enumerated() {
                    self?.tags[index].text = "#\(tag)"
                }
            })
            .disposed(by: disposeBag)
        
        
        // URL Link
        viewModel.urlLinksRelay
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] value in
                self?.viewModel.linkViewSetting()
            })
            .disposed(by: disposeBag)
        
        viewModel.linksDataRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] links in
                self?.urlViewSetting()
            })
            .disposed(by: disposeBag)
    }
}

// MARK:- UI

extension ArticleDetailViewController {
    func viewDesign() {
        articleCategory.articleCategoryDesign()
        adjustUITextViewHeight(arg: textView)
        //        drawImage()
    }
    
    // 내용 본문에 Height에 맞게 조절하기 위해
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func drawImage() {
        let imageURL: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/articlePosts%2F0XgA8G0aM2FjkVaQ4aE4%2Fimage-1.png?alt=media&token=b29bfc85-42b6-4b46-8d44-bf2fce231961")!
        let imageView: UIImageView = UIImageView()
        imageView.kf.setImage(with: imageURL)
        
        guard let image = imageView.image else {
            return
        }
        
        let scaledHeight = ((UIScreen.main.bounds.width - 40) * image.size.height) / image.size.width
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
    }
}

// MARK: - UploadImage

extension ArticleDetailViewController {
    
    func imageStackViewSetting() {
        let imagesURL: [URL?] = [
            URL(string: "https://pgnqdrjultom1827145.cdn.ntruss.com/img/ae/f3/aef3ae5264766dc154b3f30b368a3a64096ce0993b093d162854686603395567_v1.jpg"),
            URL(string: "https://pgnqdrjultom1827145.cdn.ntruss.com/img/0d/6a/0d6ac8d2982213ef8d6c6a4047b6177c43284cda2f45414d2471ad6624c4e82f_v1.jpg"),
            URL(string: "https://pgnqdrjultom1827145.cdn.ntruss.com/img/3e/46/3e46b0c57e9cb76283711cb30dc8cc20867cd581c5b03501a740ad85187ed328_v1.jpg"),
            
        ]
        
        for (index, imageURL) in imagesURL.enumerated() {
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
                                        print("scaleHeight : \(scaledHeight)")
                                        imageStackView.addArrangedSubview(imageView)
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
        let videosURL: [URL?] = [
            URL(string: "http://hongikdmd.com/breathe/static/video/promotion.mp4"),
            URL(string: "https://media.fmkorea.com/files/attach/new/20200121/486616/624031606/2625407645/37eed0627b2ef15be50ba8d451a33094.mp4?d"),
            URL(string: "https://media.fmkorea.com/files/attach/new/20200305/3655109/524068279/2790265601/972b3182d8136d27e745a7db6d3e443f.mp4?d")
            
        ]
        
        for (index, videoURL) in videosURL.enumerated() {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            videoStackView.addArrangedSubview(imageView)
            
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
            AVAsset(url: videoURL!).generateThumbnail(completion: { [weak self] image in
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
        for linkData in viewModel.linksDataRelay.value {
            let containerView: UIView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.layer.borderWidth = 1.5
            containerView.layer.borderColor = UIColor.appColor(.white235).cgColor
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
            containerView.backgroundColor = .clear
            
            urlStackView.addArrangedSubview(containerView)
            containerView.leadingAnchor.constraint(equalTo: urlStackView.leadingAnchor, constant: 0).isActive = true
            containerView.trailingAnchor.constraint(equalTo: urlStackView.trailingAnchor, constant: 0).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            
            let imageView: UIImageView = UIImageView()
            //        let stringImageURL = URL(string: viewModel.linksDataRelay.value[0].image)
            imageView.kf.setImage(with: URL(string: "\(linkData.image)"))
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
