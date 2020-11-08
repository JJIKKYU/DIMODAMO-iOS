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
    var currentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        
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
        
        
        print("indexpath : \(indexPath.row)")
        let dptiResults: [DptiResult] = self.viewModel.typeFArr
        print("dptiresultsCount = \(dptiResults.count)")
        if dptiResults.count == 0 { return cell }
        let type = dptiResults[indexPath.row].type
        let shape = dptiResults[indexPath.row].shape
        cell.lottieChar(typeGender: "M_\(type)")
        cell.resultCardView.backgroundColor = UIColor.dptiDarkColor("M_FI")
        cell.typeTitle.text = dptiResults[indexPath.row].title
        cell.typeIcon.image = UIImage(named: "BC_Type_\(shape)")
        cell.bgPattern.image = UIImage(named: "BC_BG_P_\(shape)")
        
        
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
        
        let layout = firstCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        firstCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        
        // 스크롤 시 빠르게 감속 되도록 설정
        firstCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
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
