//
//  HotDimoPeopleVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HotDimoPeopleVC: UIViewController {
    
    let viewModel = HotDimoPeopleViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableViewTopContainer: UIView!
    @IBOutlet weak var filterButtonContainer: UIView! {
        didSet {
            filterButtonContainer.layer.cornerRadius = 4
            filterButtonContainer.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var filterBtnArrow: UIImageView!
    @IBOutlet var stackViews: [UIStackView]!
    
    /*
     Sahdow Setting
     */
    let aspectWidth = (304 / 414) * UIScreen.main.bounds.width
    let spacing: CGFloat = UIScreen.main.bounds.width / 26
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            let cellWidthHeight = (aspectWidth - spacing * 3) / 4
            
            for btn in buttons {
                
                btn.appShadow(.s4)
                
                // 마지막 버튼일 경우
                if btn.tag == 20 {
                    let height = cellWidthHeight * 0.4375
                    
                    btn.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                } else {
                    btn.widthAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
                    btn.heightAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
                }
                
            }
        }
    }
    
    @IBOutlet weak var filterContainer: UIView!
    
    /*
     mainTableView
     */
    @IBOutlet weak var tableView: UITableView!
    
    
    override func loadView() {
        super.loadView()
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray190)
        animate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray190)
        navigationController?.navigationBar.barTintColor = .white
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource =  self
        settingTableView()
        
        // 기본은 필터가 올라가있는 상태로
        self.filter(isTurnOn: true)
        
        for index in 0...8 {
            buttons[index].rx.tap
                .scan(false) { lastValue, _ in
                    return !lastValue
                }
                .bind(to: buttons[index].rx.isSelected)
                .disposed(by: disposeBag)
        }
        
        /*
         로딩이 됐을 경우 테이블 리로드
         */
        viewModel.hotDimoPeopleArrIsLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag == true {
                    self?.tableView.reloadData()
                } else {
                    print("loading...")
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    @IBAction func pressedFilterBtn(_ sender: Any) {
        print("pressedFilterBtn")
        
        switch viewModel.isTurnOnFilter {
        
        // 이미 필터가 켜져있을 경우
        case true:
            self.filter(isTurnOn: false)
            break
            
        // 필터가 꺼져있을 경우
        case false:
            self.filter(isTurnOn: true)
            break
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        switch identifier {
        case "MyProfileVC":
            let index: Int = sender as! Int
            let destination = segue.destination as! MyProfileVC
            
            var selectedUserUID: String?
            
            selectedUserUID = viewModel.hotDimoPeopleArr[index].uid
            destination.viewModel.profileSetting.accept(viewModel.hotDimoPeopleArr[index].dpti)
            destination.viewModel.userNickname = viewModel.hotDimoPeopleArr[index].nickname
            
            guard let UID = selectedUserUID else {
                return
            }
            
            destination.viewModel.profileUID.accept(UID)
            
            break
        default:
            break
        }
    }
    
}

//MARK: - FilterBtnAction
extension HotDimoPeopleVC {
    func filter(isTurnOn: Bool) {
        let turnOnHeight: CGFloat = 200
        let turnOffHeight: CGFloat = 460
        
        var newHaderViewFrame = tableView.tableHeaderView!.frame
        switch isTurnOn {
        case true:
            newHaderViewFrame.size.height = turnOnHeight
            self.filterContainer.isHidden = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.filterBtnArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            print("true")
            break
            
        case false:
            newHaderViewFrame.size.height = turnOffHeight
            self.filterContainer.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.filterBtnArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            }
            
            print("false")
            break
        }
        
        let tableHeaderView = tableView.tableHeaderView
        
        // 애니메이션을 넣으려면 여기로
        tableHeaderView!.frame = newHaderViewFrame
        self.tableView.tableHeaderView = tableHeaderView
        
        viewModel.isTurnOnFilter = isTurnOn
    }
}

//MARK: - TableView

extension HotDimoPeopleVC: UITableViewDelegate, UITableViewDataSource {
    func settingTableView() {
        tableView.rowHeight = 242
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hotDimoPeopleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DamoPeopleCell", for: indexPath) as! DamoPeopleCell
        
        let index = indexPath.row
        let hotDimoArr = viewModel.hotDimoPeopleArr[index]
        
        cell.nickname.text = hotDimoArr.nickname
        cell.profile.image = hotDimoArr.getProfileImage()
        cell.topContainer.backgroundColor = hotDimoArr.getBackgroundColor()
        cell.typeImage.image = hotDimoArr.getTypeImage()
        cell.backgroundPattern.image = hotDimoArr.getBackgroundPattern()
        
        cell.commentHeartCount.text = "+\(hotDimoArr.commentHeartCount)"
        cell.manitoCount.text = "+\(hotDimoArr.manitoGoodCount)"
        cell.scrapCount.text = "+\(hotDimoArr.documnetScrapCount)"
        
        cell.commentHeartIcon.image = hotDimoArr.getMedal(kind: .comment)
        cell.scrapIcon .image = hotDimoArr.getMedal(kind: .scrap)
        cell.manitoIcon.image = hotDimoArr.getMedal(kind: .manito)
        
        
        /*
         랭킹
         */
        let lankString: String = "\(index + 1)위"
        let stringLocation: Int = (String(index + 1).count - 1) + 1
        var lankMutableString = NSMutableAttributedString()
        lankMutableString = NSMutableAttributedString(
            string: lankString,
            attributes: [NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Semibold", size: 16.0)!])
        lankMutableString.addAttribute(
            NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeoEB00", size: 12.0)!,
            range: NSRange(location: stringLocation ,length:1))
        cell.rankingLabel.attributedText = lankMutableString
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MyProfileVC", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // need to pass your indexpath then it showing your indicator at bottom
        tableView.addLoading(indexPath) {
            // add your code here
            // append Your array and reload your tableview
            tableView.stopLoading() // stop your indicator
        }
    }
}
