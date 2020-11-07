//
//  MyProfileVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

enum MyProfileMoreBtn: Int {
    case like = 0
    case scrap = 1
    case heart = 2
}

class MyProfileVC: UIViewController {
    
    let viewModel = MyProfileViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var topStretchBG: UIView!
    @IBOutlet weak var backgroundPattern: UIImageView!
    @IBOutlet weak var bubblePopup: UIImageView!
    @IBOutlet weak var menuBtn: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var navItem: UINavigationItem!
    /*
     ProfileContainer
     */
    @IBOutlet weak var profileBG: UIView! {
        didSet {
            profileBG.layer.cornerRadius = profileBG.frame.height / 2
            profileBG.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var type: UIImageView!
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var commentHeartCountLabel: UILabel!
    @IBOutlet weak var scrapCountLabel: UILabel!
    @IBOutlet weak var manitoGoodCountLabel: UILabel!
    
    /*
     Tags
     */
    @IBOutlet var tags: [UILabel]! {
        didSet {
            for tag in tags {
                tag.layer.borderWidth = 1.5
                tag.layer.borderColor = UIColor.appColor(.system).cgColor
                tag.layer.cornerRadius = tag.frame.height / 2
                tag.layer.masksToBounds = true
                
                tag.widthAnchor.constraint(equalToConstant: 73).isActive = true
                tag.textAlignment = .center
                tag.attributedText = NSAttributedString.init(string: "안녕", attributes: [NSAttributedString.Key.baselineOffset : -1])
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        animate()
        
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
        }, completion: nil)
    }
    
    private func setColors() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Profile 컬러 및 도형 위주로 세팅
         */
        viewModel.profileSetting
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] typeString in
                
                guard let userNickname = self?.viewModel.userNickname else {
                    return
                }
                
                // 정상적으로 값이 들어오는 경우
                if typeString != "" {
                    self?.nicknameLabel.text = "\(userNickname)"
                    self?.profile.image = UIImage(named: "Profile_\(typeString)")
                    self?.type.image = UIImage.dptiProfileTypeIcon(typeString, isFiiled: true)
                    self?.topContainer.backgroundColor = UIColor.dptiDarkColor(typeString)
                    self?.topStretchBG.backgroundColor = UIColor.dptiDarkColor(typeString)
                    self?.backgroundPattern.image = UIImage.shapeBackgroundPattern(typeString)
                } else {
                    
                }
            })
            .disposed(by: disposeBag)
        
        
        /*
         정량적 데이터
         */
        viewModel.userProfileData
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                
                
                self?.commentHeartCountLabel.text = "+\(data.commentHeartCount)"
                self?.scrapCountLabel.text = "+\(data.scrapCount)"
                self?.manitoGoodCountLabel.text = "+\(data.manitoGoodCount)"
                
                for (index, tag) in self!.tags.enumerated() {
                    tag.text = "\(data.interests[index])"
                    tag.text = "\(Interest.getWordFromString(from: data.interests[index]))"
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
    /*
     활동 내역에서 모두 보기 눌렀을 경우
     */
    
    @IBAction func pressedMoreBtn(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        
        switch btn.tag {
        case MyProfileMoreBtn.like.rawValue:
            break
            
        case MyProfileMoreBtn.scrap.rawValue:
            break
            
        case MyProfileMoreBtn.heart.rawValue:
            break
            
        default:
            break
        }
        
        print("클릭")
        performSegue(withIdentifier: "ArchiveVC", sender: nil)
        //        performSegue(withIdentifier: "ArchiveVC", sender: nil)
    }
    
    /*
     Dpti 버튼을 눌렀을 경우
     */
    @IBAction func pressedDptiBtn(_ sender: Any) {
        performSegue(withIdentifier: "MyDptiVC", sender: sender)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        switch segue.identifier {
        case "MyDptiVC":
            let destinationVC = destination
            break
            
        case "ArchiveVC":
            break
            
        default:
            break
        }
    }
    
}
