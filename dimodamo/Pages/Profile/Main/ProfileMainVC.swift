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

    @IBOutlet weak var dimoCollectionView: UICollectionView!
    var currentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    @IBOutlet weak var damoTableView: UITableView!
    
    let viewModel = ProfileMainViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        navigationController?.view.backgroundColor = UIColor.clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimoCollectionView.delegate = self
        dimoCollectionView.dataSource = self
        
        damoTableView.delegate = self
        damoTableView.dataSource = self
        
        dimoCollectionViewSetting()
        settingTableView()

        // Do any additional setup after loading the view.
    }
    
    /*
     우측 상단에 있는 프로필 사진을 눌렀을 경우
     */
    @IBAction func pressedMyProfileBtn(_ sender: Any) {
        performSegue(withIdentifier: "MyProfileVC", sender: sender)
    }
    
    /*
     추천 디모인 / 더 보기를 클릭할 때
     */
    @IBAction func pressedDimoPeopleBtn(_ sender: Any) {
        performSegue(withIdentifier: "DimoPeopleVC", sender: sender)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - 추천 디모인
extension ProfileMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DimoPeopleCell", for: indexPath)
        
        return cell
    }
    
    func dimoCollectionViewSetting() {
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
        dimoCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX - 4, bottom: insetY, right: insetX - 4)
        
        
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DamoPeopleCell", for: indexPath)
        
        return cell
    }
    
    
}
