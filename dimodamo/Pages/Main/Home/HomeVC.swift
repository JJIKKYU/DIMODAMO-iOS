//
//  HomeVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    /*
     ServiceBanner Variables
     */
    @IBOutlet weak var serviceBannerCollectionView: UICollectionView!
    @IBOutlet weak var serviceBanner: UICollectionView!
    var currentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    /*
     최신 아트보드
     */
    @IBOutlet weak var magazineLabel: PaddingLabel! {
        didSet {
            magazineLabel.layer.borderColor = UIColor.appColor(.system).cgColor
            magazineLabel.layer.borderWidth = 2
            magazineLabel.layer.cornerRadius = magazineLabel.frame.height / 2
            magazineLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var artboardCardViewShadow: UIView! {
        didSet {
            artboardCardViewShadow.appShadow(.s12)
            artboardCardViewShadow.layer.cornerRadius = 24
            
        }
    }
    @IBOutlet weak var artboardCardView: UIView! {
        didSet {
            artboardCardView.layer.cornerRadius = 24
            artboardCardView.layer.masksToBounds = true
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션바 하단 밑줄 제거
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // 네비게이션바 하단 그림자 추가
        self.tabBarController?.tabBar.layer.masksToBounds = false
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.barStyle = .black
        self.tabBarController?.tabBar.layer.cornerRadius = 24
        self.tabBarController?.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBarController?.tabBar.appShadow(.s20)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        serviceBannerCollectionView.delegate = self
        serviceBannerCollectionView.dataSource = self
        self.serviceBannerCollectionViewSetting()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressedSettingBtn(_ sender: Any) {
        performSegue(withIdentifier: "testVC", sender: nil)
    }
}

//MARK: - Service Banner

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceBannerCell", for: indexPath) as! ServiceBannerCell
        
        let index = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        performSegue(withIdentifier: "MyProfileVC", sender: [DimoKinds.dimo.rawValue, index])
    }
    
    func serviceBannerCollectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 48
        let cellHeight: CGFloat = 88
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        
        let layout = serviceBannerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        serviceBannerCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX - 8)
        
        // 스크롤 시 빠르게 감속 되도록 설정
        serviceBannerCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}

extension HomeVC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.serviceBannerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
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
