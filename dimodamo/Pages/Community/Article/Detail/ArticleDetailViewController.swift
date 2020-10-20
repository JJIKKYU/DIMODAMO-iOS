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

class ArticleDetailViewController: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var articleCategory: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var videoStackView: UIStackView!
    @IBOutlet weak var videoStackViewHeight: NSLayoutConstraint!
    
    var imageView1: UIImageView = UIImageView()
    
    var article: Article?
    var disposeBag = DisposeBag()
    let viewModel = ArticleDetailViewModel()
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        // 이 페이지에서 나갈때 라지 타이틀을 비활성화 했으므로 다시 활성화 해주고 나감
//        navigationController?.visible(color: UIColor.appColor(.textBig))
//
//        // 하단 탭바 다시 보이도록
//        (self.tabBarController as? TabBarViewController)?.visible()
//
//        // < 이전 버튼 다시 원래 컬러로 변경
//        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray170)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDesign()
        
        imageStackViewSetting()
        videoStackViewSetting()
        
        navigationController?.invisible()
//        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
        
        // 하단 탭바 숨기기
        (self.tabBarController as? TabBarViewController)?.invisible()
        
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
        
        viewModel.tagsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                for (index, tag) in tags.enumerated() {
                    self?.tags[index].text = "#\(tag)"
                }
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
        imageStackViewHeight.isActive = false
        let imagesURL: [URL?] = [
            URL(string: "https://i.pinimg.com/originals/39/ce/87/39ce877f154321edbe61888926ae2554.jpg"),
            URL(string: "https://pbs.twimg.com/media/DkakGNKU8AAaGBN.jpg:large")
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
                    
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            })
            print("index : => \(index)")
            imageStackView.layoutIfNeeded()
        }
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.sizeToFit()
    }
}

// MARK: - Video

extension ArticleDetailViewController {
    func videoStackViewSetting() {
        
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
