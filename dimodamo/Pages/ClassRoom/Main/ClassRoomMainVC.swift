//
//  ClassRoomMainVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ClassRoomMainVC: UIViewController {

    /*
     CollectionView
     TableView
     */
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var bestCollectionView: UICollectionView!
    @IBOutlet weak var newTableView: UITableView!
    var currentIndex: CGFloat = 0
    var secondCurrentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        
        bestCollectionView.delegate = self
        bestCollectionView.dataSource = self
        
        newTableView.delegate = self
        newTableView.dataSource = self
        self.settingTableView()
        self.collectionViewSetting()
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

//MARK: - CollectionView (추천 과방, 베스트 과방)

extension ClassRoomMainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DimoPeopleCell", for: indexPath) as! DimoPeopleCell
        
//        let index = indexPath.row
//        let dimoArr = viewModel.dimoPeopleArr
//
//        cell.nickname.text = dimoArr[index].nickname
//        cell.profile.image = dimoArr[index].getProfileImage()
//        cell.topContainer.backgroundColor = dimoArr[index].getBackgroundColor()
//        cell.typeImage.image = dimoArr[index].getTypeImage()
//        cell.backgroundPattern.image = dimoArr[index].getBackgroundPattern()
//
//        for (tagIndex, tag) in cell.tags.enumerated() {
//            tag.text = Interest.getWordFromString(from: dimoArr[index].interests[tagIndex])
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        performSegue(withIdentifier: "ClassRoomDetailVC", sender: [DimoKinds.dimo.rawValue, index])
    }
    
    func collectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 48
        let cellHeight: CGFloat = 180
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        
        let layout = recommendCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        
        let bestCollectionViewLayout = bestCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        bestCollectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        bestCollectionViewLayout.minimumLineSpacing = lineSpacing
        bestCollectionViewLayout.scrollDirection = .horizontal
        
        recommendCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX - 4, bottom: insetY, right: insetX - 8)
        bestCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX - 8)
        
        // 스크롤 시 빠르게 감속 되도록 설정
        recommendCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        bestCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}

//MARK: - CollectionView Paging

extension ClassRoomMainVC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.recommendCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
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
        
        switch scrollView.tag {
        case 0:
            if isOneStepPaging {
                if currentIndex > roundedIndex {
                    currentIndex -= 1
                    roundedIndex = currentIndex
                } else if currentIndex < roundedIndex {
                    currentIndex += 1
                    roundedIndex = currentIndex
                }
            }
            break
            
        case 1:
            if isOneStepPaging {
                if secondCurrentIndex > roundedIndex {
                    secondCurrentIndex -= 1
                    roundedIndex = secondCurrentIndex
                } else if secondCurrentIndex < roundedIndex {
                    secondCurrentIndex += 1
                    roundedIndex = secondCurrentIndex
                }
            }
            break
            
        default:
            break
        }
        
        
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

//MARK: - newTableView

extension ClassRoomMainVC: UITableViewDelegate, UITableViewDataSource {
    func settingTableView() {
        newTableView.rowHeight = 242
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DamoPeopleCell", for: indexPath) as! DamoPeopleCell
        
//        let index = indexPath.row
//        let hotDimoArr = viewModel.hotDimoPeopleArr[index]
//
//        cell.nickname.text = hotDimoArr.nickname
//        cell.profile.image = hotDimoArr.getProfileImage()
//        cell.topContainer.backgroundColor = hotDimoArr.getBackgroundColor()
//        cell.typeImage.image = hotDimoArr.getTypeImage()
//        cell.backgroundPattern.image = hotDimoArr.getBackgroundPattern()
//
//        cell.commentHeartCount.text = "+\(hotDimoArr.commentHeartCount)"
//        cell.manitoCount.text = "+\(hotDimoArr.manitoGoodCount)"
//        cell.scrapCount.text = "+\(hotDimoArr.documnetScrapCount)"
//
//        cell.commentHeartIcon.image = hotDimoArr.getMedal(kind: .comment)
//        cell.scrapIcon .image = hotDimoArr.getMedal(kind: .scrap)
//        cell.manitoIcon.image = hotDimoArr.getMedal(kind: .manito)
//
//
//        /*
//         랭킹
//         */
//        let lankString: String = "\(index + 1)위"
//        let stringLocation: Int = (String(index + 1).count - 1) + 1
//        var lankMutableString = NSMutableAttributedString()
//        lankMutableString = NSMutableAttributedString(
//            string: lankString,
//            attributes: [NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Semibold", size: 16.0)!])
//        lankMutableString.addAttribute(
//            NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeoEB00", size: 12.0)!,
//            range: NSRange(location: stringLocation ,length:1))
//        cell.rankingLabel.attributedText = lankMutableString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        performSegue(withIdentifier: "ClassRoomDetailVC", sender: [DimoKinds.hotDimo.rawValue, index])
//        print(viewModel.hotDimoPeopleArr[index].uid)
    }
}
