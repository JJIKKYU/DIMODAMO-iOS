//
//  ProfileMainVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ProfileMainVC: UIViewController {
    
    let viewModel = ProfileMainViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var navProfileBtn: UIButton!
    @IBOutlet weak var dimoCollectionView: UICollectionView!
    var currentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    @IBOutlet weak var damoTableView: UITableView!
    
    override func loadView() {
        super.loadView()
        setColors()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.presentTransparentNavigationBar()
        
        // 네비게이션바 하단 밑줄 제거
        // 네비게이션바 하단 그림자 추가
        DispatchQueue.main.async {
            self.tabBarController?.roundedTabbar()
            self.navigationController?.hideBottomTabbarLine()
        }
        view.layoutIfNeeded()
        
        animate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
//        navigationController?.view.backgroundColor = UIColor.clear
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
        
        // 네비게이션바 하단 밑줄 제거
        // 네비게이션바 하단 그림자 추가
        DispatchQueue.main.async {
            self.tabBarController?.roundedTabbar()
            self.navigationController?.hideBottomTabbarLine()
        }
        view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimoCollectionView.delegate = self
        dimoCollectionView.dataSource = self
        
        damoTableView.delegate = self
        damoTableView.dataSource = self
        
        dimoCollectionViewSetting()
        settingTableView()
        
        /*
         유저 프로필 세팅
         */
        viewModel.profileSetting
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] typeString in
                
                // 정상적으로 값이 들어오는 경우
                if typeString != "" {
                    self?.navProfileBtn.setImage(UIImage(named: "24_Profile_\(typeString)"), for: .normal)
                } else {
                    
                }
            })
            .disposed(by: disposeBag)
        
        /*
         디모인
         */
        viewModel.dimoPeopleArrIsLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag == false {
                    print("디모인을 로딩중입니다.")
                } else {
                    print("디모인 로딩이 완료되어 컬렉션 뷰를 리로딩 합니다.")
                    self?.dimoCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        /*
         핫한 디모인
         */
        viewModel.hotDimoPeopleArrIsLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag == false {
                    print("핫한 디모인을 로딩중입니다.")
                } else {
                    print("핫한 디모인 로딩이 완료되어 컬렉션 뷰를 리로딩 합니다.")
                    self?.damoTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    /*
     우측 상단에 있는 프로필 사진을 눌렀을 경우
     */
    @IBAction func pressedMyProfileBtn(_ sender: Any) {
        performSegue(withIdentifier: "MyProfileVC", sender: [DimoKinds.myProfile.rawValue, -1])
    }
    
    /*
     검색 버튼을 눌렀을 경우
     */
    @IBAction func pressedSearchBtn(_ sender: Any) {
        performSegue(withIdentifier: "ProfileSearchVC", sender: sender)
    }
    
    /*
     추천 디모인 / 더 보기를 클릭할 때
     */
    @IBAction func pressedDimoPeopleBtn(_ sender: Any) {
        performSegue(withIdentifier: "DimoPeopleVC", sender: sender)
    }
    
    /*
     핫한 디모인
     */
    @IBAction func pressedHotDimoPeople(_ sender: Any) {
        performSegue(withIdentifier: "HotDimoPeopleVC", sender: sender)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        switch identifier {
        case "MyProfileVC":
            let senderData: [Int] = sender as! [Int]
            let destination = segue.destination as! MyProfileVC
            let arrIndex: Int = senderData[1] as Int
            
            var selectedUserUID: String?
            
            switch senderData[0] {
            case DimoKinds.myProfile.rawValue:
                print(viewModel.userUID)
                selectedUserUID = viewModel.userUID
                destination.viewModel.profileSetting.accept(viewModel.myDptiType())
                destination.viewModel.userNickname = viewModel.myNickname()
                break
                
            case DimoKinds.dimo.rawValue:
                print(viewModel.userUID)
                selectedUserUID = viewModel.dimoPeopleArr[arrIndex].uid
                destination.viewModel.profileSetting.accept(viewModel.dimoPeopleArr[arrIndex].dpti)
                destination.viewModel.userNickname = viewModel.dimoPeopleArr[arrIndex].nickname
                break
                
            case DimoKinds.hotDimo.rawValue:
                selectedUserUID = viewModel.hotDimoPeopleArr[arrIndex].uid
                destination.viewModel.profileSetting.accept(viewModel.hotDimoPeopleArr[arrIndex].dpti)
                destination.viewModel.userNickname = viewModel.hotDimoPeopleArr[arrIndex].nickname
                break
                
            default:
                break
            }
            
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

// MARK: - 추천 디모인
extension ProfileMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // DPTI를 진행하지 않았을 경우
        if viewModel.interactionIsAbailable() == false {
            return 1
        }
        
        return viewModel.dimoPeopleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        // DPTI를 진행하지 않았을 경우
        if viewModel.interactionIsAbailable() == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionCell", for: indexPath)
            return cell
        }
        
        // DPTI를 진행했을 경우
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DimoPeopleCell", for: indexPath) as! DimoPeopleCell
        let index = indexPath.row
        let dimoArr = viewModel.dimoPeopleArr

        cell.nickname.text = dimoArr[index].nickname
        cell.profile.image = dimoArr[index].getProfileImage()
        cell.topContainer.backgroundColor = dimoArr[index].getBackgroundColor()
        cell.typeImage.image = dimoArr[index].getTypeImage()
        cell.backgroundPattern.image = dimoArr[index].getBackgroundPattern()

        for (tagIndex, tag) in cell.tags.enumerated() {
            tag.text = Interest.getWordFromString(from: dimoArr[index].interests[tagIndex])
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // DPTI를 진행하지 않았을 경우
        if viewModel.interactionIsAbailable() == false {
            DptiPopupManager.dptiPopup(popupScreen: .profile, vc: self)
            return
        }
        
        let index = indexPath.row
        performSegue(withIdentifier: "MyProfileVC", sender: [DimoKinds.dimo.rawValue, index])
    }
    
    func dimoCollectionViewSetting() {
        // Empty Xib 설정, DPTI를 안했을 경우에만
        if viewModel.interactionIsAbailable() == false {
            let nibName = UINib(nibName: "EmptyCollectionCell", bundle: nil)
            dimoCollectionView.register(nibName, forCellWithReuseIdentifier: "EmptyCollectionCell")
            return
        }
        
        
        
        
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 48
        let cellHeight: CGFloat = 172
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        
        let layout = dimoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        dimoCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX - 8)
        
        // 스크롤 시 빠르게 감속 되도록 설정
        dimoCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}


// MARK: - Dimo Paging

extension ProfileMainVC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.dimoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}


// MARK: - 핫한 디모인
extension ProfileMainVC: UITableViewDelegate, UITableViewDataSource {
    func settingTableView() {
        damoTableView.rowHeight = 242
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
        cell.topContainerBottomView.backgroundColor = hotDimoArr.getBackgroundColor()
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
        let index = indexPath.row
        
        performSegue(withIdentifier: "MyProfileVC", sender: [DimoKinds.hotDimo.rawValue, index])
        //        print(viewModel.hotDimoPeopleArr[index].uid)
    }
    
    
}
