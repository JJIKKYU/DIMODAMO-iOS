//
//  CommunityMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/20.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import WebKit

import RxSwift
import RxCocoa

class CommunityMainViewController: UIViewController {
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // Paging Variable (articleCollectionView)
    var currentIndex: CGFloat = 0
    let lineSpacing: CGFloat = 20
    var isOneStepPaging = true
    
    let viewModel = CommunityMainViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // UI 및 delegate 세팅
        tableView.delegate = self
        tableView.dataSource = self
        
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        
        settingTableView()
        articleCollectionViewSetting()
        setupUI()
        
        
        Observable.combineLatest(
            viewModel.imageLoading,
            viewModel.profileLoading
        )
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageLoading, profileLoading  in
                if imageLoading == true && profileLoading == true {
                    self?.articleCollectionView.reloadData()
                    self?.articleCollectionView.layoutIfNeeded()
                    print("ㅇㅋㅇㅋ")
                }
            })
            .disposed(by: disposeBag)
        
        // 바인딩
        
    }
    
    // MARK: - IBaction
    
    // 디모다모 교과서 타이틀을 눌렀을 경우
    @IBAction func pressedArticleTitle(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.article)", sender: sender)
    }
    
    // 디모다모 교과서 더보기를 눌렀을 경우
    @IBAction func pressedArticleMoreBtn(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.article)", sender: sender)
    }
    
    @IBAction func pressedInformationTitle(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.information)", sender: sender)
    }
    @IBAction func pressedInformationMoreBtn(_ sender: Any) {
        performSegue(withIdentifier: "\(CommunitySegueName.information)", sender: sender)
    }
    
    @objc func pressedSearchBtn(sender: UIButton) {
        print("pressedSeearchBtn")
    }
    
    @objc func pressedPlusBtn(sender: UIButton) {
        print("pressedPlusBtn")
    }
    
    // MARK: - UI

    private func setupUI() {
        
        // 돋보기 버튼 이미지
        let navigationSearchBtn: UIButton = UIButton(type: .custom)
        if let image = UIImage(named: "searchIcon") {
            navigationSearchBtn.setImage(image, for: .normal)
        }
        navigationSearchBtn.addTarget(self, action: #selector(self.pressedSearchBtn(sender:)), for: .touchUpInside)

        
        let navigationPlusBtn: UIButton = UIButton(type: .custom)
        if let image = UIImage(named: "plusBtn") {
            navigationPlusBtn.setImage(image, for: .normal)
        }
        navigationPlusBtn.addTarget(self, action: #selector(self.pressedPlusBtn(sender:)), for: .touchUpInside)

        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        // NavigationSearchBtn
        navigationBar.addSubview(navigationSearchBtn)
        navigationSearchBtn.clipsToBounds = true
        navigationSearchBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationSearchBtn.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -NavigationBarConst.ImageRightMargin - 30),
            navigationSearchBtn.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -NavigationBarConst.ImageBottomMarginForLargeState),
            navigationSearchBtn.heightAnchor.constraint(equalToConstant: NavigationBarConst.ImageSizeForLargeState),
            navigationSearchBtn.widthAnchor.constraint(equalTo: navigationSearchBtn.heightAnchor)
        ])
        
        // NavigationPlusBtn
        navigationBar.addSubview(navigationPlusBtn)
        navigationPlusBtn.clipsToBounds = true
        navigationPlusBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationPlusBtn.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -NavigationBarConst.ImageRightMargin),
            navigationPlusBtn.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -NavigationBarConst.ImageBottomMarginForLargeState),
            navigationPlusBtn.heightAnchor.constraint(equalToConstant: NavigationBarConst.ImageSizeForLargeState),
            navigationPlusBtn.widthAnchor.constraint(equalTo: navigationPlusBtn.heightAnchor)
        ])
    }
    
    
}

// MARK: - TableView (Information)(

extension CommunityMainViewController: UITableViewDataSource, UITableViewDelegate {
    func settingTableView() {
        tableView.rowHeight = 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("호출")
//        return CGFloat(CellHeight.informationHeight)
//    }
}

// MARK: - CollectionView (Article)

extension CommunityMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Article", for: indexPath) as! ArticleCell
        
        let model = viewModel.articles[indexPath.row]
        
        if let loadedImage = viewModel.articles[indexPath.row].image {
            cell.image.image = UIImage(data: loadedImage)
        }
        
        if let loadedProfile = viewModel.articles[indexPath.row].profile {
            cell.profile.image = UIImage(data: loadedProfile)

        }
        
        cell.title.text = model.title
        
        cell.tags[0].text = "#\(model.tags![0])"
        cell.tags[1].text = "#\(model.tags![1])"
        cell.tags[2].text = "#\(model.tags![2])"
        
        cell.nickname.text = model.nickname
        cell.scrapCnt.text = "\(model.scrapCnt!)"
        cell.commentCnt.text = "\(model.commentCnt!)"
        
        //TODO: Configure cell
        return cell
    }
    
    // 선택한 아이템
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailArticleVC_Main", sender: nil)
        print(indexPath.row)
    }
}

// MARK: - Article Paging

extension CommunityMainViewController : UIScrollViewDelegate {
    
    func articleCollectionViewSetting() {
        // width, height 설정
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 48
        let cellHeight: CGFloat = 437
        
        // 상하, 좌우 inset value 설정
        let insetX: CGFloat = 20
        let insetY: CGFloat = 20
        
        let layout = articleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        articleCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX - 4, bottom: insetY, right: insetX - 4)
        
        
        // 스크롤 시 빠르게 감속 되도록 설정
        articleCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.articleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
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
