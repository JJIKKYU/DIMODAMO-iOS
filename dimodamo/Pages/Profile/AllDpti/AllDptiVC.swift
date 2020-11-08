//
//  AllDptiVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AllDptiVC: UIViewController {

    let viewModel = AllDptiViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var thirdCollectionView: UICollectionView!
    @IBOutlet weak var fourthCollectionView: UICollectionView!
    var currentIndex: CGFloat = 0
    var secondCurrentIndex: CGFloat = 0
    var thirdCurrentIndex: CGFloat = 0
    var fourthCurrentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        
        thirdCollectionView.dataSource = self
        thirdCollectionView.delegate = self
        
        fourthCollectionView.dataSource = self
        fourthCollectionView.delegate = self
        
        collectionViewSetting()
        // Do any additional setup after loading the view.
        
        viewModel.resultObservable
            .subscribe(onNext: { [weak self] _ in
//                print(self?.viewModel.typeTresults)
                self?.firstCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension AllDptiVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllDptiCell", for: indexPath) as? AllDptiCell else {
            return UICollectionViewCell()
        }
        
        switch collectionView.tag {
        // 감정풍부형
        case 0:
            let dptiResults: [DptiResult] = self.viewModel.typeFArr
            if dptiResults.count == 0 { return cell }
            let type = dptiResults[indexPath.row].type
            let shape = dptiResults[indexPath.row].shape
            cell.lottieChar(typeGender: "F_\(type)")
            cell.resultCardView.backgroundColor = UIColor.dptiDarkColor("M_FI")
            cell.typeTitle.text = dptiResults[indexPath.row].title
            cell.typeIcon.image = UIImage(named: "BC_Type_\(shape)")
            cell.bgPattern.image = UIImage(named: "BC_BG_P_\(shape)")
            break
        // 상상표출형
        case 1:
            let dptiResults: [DptiResult] = self.viewModel.typePArr
            if dptiResults.count == 0 { return cell }
            let type = dptiResults[indexPath.row].type
            let shape = dptiResults[indexPath.row].shape
            cell.lottieChar(typeGender: "F_\(type)")
            cell.resultCardView.backgroundColor = UIColor.dptiDarkColor("M_PI")
            cell.typeTitle.text = dptiResults[indexPath.row].title
            cell.typeIcon.image = UIImage(named: "BC_Type_\(shape)")
            cell.bgPattern.image = UIImage(named: "BC_BG_P_\(shape)")
            break
            
        // 현실직시형
        case 2:
            let dptiResults: [DptiResult] = self.viewModel.typeTArr
            if dptiResults.count == 0 { return cell }
            let type = dptiResults[indexPath.row].type
            let shape = dptiResults[indexPath.row].shape
            cell.lottieChar(typeGender: "F_\(type)")
            cell.resultCardView.backgroundColor = UIColor.dptiDarkColor("M_TI")
            cell.typeTitle.text = dptiResults[indexPath.row].title
            cell.typeIcon.image = UIImage(named: "BC_Type_\(shape)")
            cell.bgPattern.image = UIImage(named: "BC_BG_P_\(shape)")
            break
            
        // 자기성찰형
        case 3:
            let dptiResults: [DptiResult] = self.viewModel.typeJArr
            if dptiResults.count == 0 { return cell }
            let type = dptiResults[indexPath.row].type
            let shape = dptiResults[indexPath.row].shape
            cell.lottieChar(typeGender: "F_\(type)")
            cell.resultCardView.backgroundColor = UIColor.dptiDarkColor("M_JI")
            cell.typeTitle.text = dptiResults[indexPath.row].title
            cell.typeIcon.image = UIImage(named: "BC_Type_\(shape)")
            cell.bgPattern.image = UIImage(named: "BC_BG_P_\(shape)")
            break
        default:
            break
        }
        
        
        
        return cell
    }
    
    func collectionViewSetting() {
        // width, height 설정
        
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 48
//        let aspectRatio: CGFloat = (360 / 414) * UIScreen.main.bounds.width
        let cellHeight: CGFloat = (334 / 360) * cellWidth
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 16
        let insetY: CGFloat = 16
        
        
        // 첫번째 콜렉션 뷰
        let firstLayout = firstCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        firstLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        firstLayout.minimumLineSpacing = lineSpacing
        firstLayout.scrollDirection = .horizontal
        firstCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        // 스크롤 시 빠르게 감속 되도록 설정
        firstCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // 두번째 콜렉션 뷰
        let secondLayout = secondCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        secondLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        secondLayout.minimumLineSpacing = lineSpacing
        secondLayout.scrollDirection = .horizontal
        secondCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        // 스크롤 시 빠르게 감속 되도록 설정
        secondCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // 세번째 콜렉션 뷰
        let thirdLayout = thirdCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        thirdLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        thirdLayout.minimumLineSpacing = lineSpacing
        thirdLayout.scrollDirection = .horizontal
        thirdCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        // 스크롤 시 빠르게 감속 되도록 설정
        thirdCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // 네번째 콜렉션 뷰
        let fourthLayout = fourthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        fourthLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        fourthLayout.minimumLineSpacing = lineSpacing
        fourthLayout.scrollDirection = .horizontal
        fourthCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        // 스크롤 시 빠르게 감속 되도록 설정
        fourthCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}

// MARK: - Horizontal Paging

extension AllDptiVC : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.firstCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
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
            
        case 2:
            if isOneStepPaging {
                if thirdCurrentIndex > roundedIndex {
                    thirdCurrentIndex -= 1
                    roundedIndex = thirdCurrentIndex
                } else if thirdCurrentIndex < roundedIndex {
                    thirdCurrentIndex += 1
                    roundedIndex = thirdCurrentIndex
                }
            }
            break
            
        case 3:
            if isOneStepPaging {
                if fourthCurrentIndex > roundedIndex {
                    fourthCurrentIndex -= 1
                    roundedIndex = fourthCurrentIndex
                } else if fourthCurrentIndex < roundedIndex {
                    fourthCurrentIndex += 1
                    roundedIndex = fourthCurrentIndex
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
