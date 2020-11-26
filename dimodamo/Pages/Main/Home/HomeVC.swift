//
//  HomeVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    let viewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    
    /*
     Navigation Profile
     */
    @IBOutlet weak var profileNavBtn: UIButton! {
        didSet {
            profileNavBtn.setImage(UIImage(named: "24_Profile_\(viewModel.myDptiType())"), for: .normal)
            self.view.layoutIfNeeded()
        }
    }
    
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
            magazineLabel.layer.cornerRadius = magazineLabel.layer.frame.height / 2
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
    @IBOutlet weak var artboardImage: UIImageView!
    @IBOutlet weak var artboardTitle: UILabel!
    @IBOutlet weak var artboardTag: UILabel!
    @IBOutlet weak var artboardProfile: UIImageView!
    @IBOutlet weak var artboardNickname: UILabel!
    @IBOutlet weak var artboardScrapCount: UILabel!
    @IBOutlet weak var artboardCommentCount: UILabel!
    
    
    override func loadView() {
        super.loadView()
        setColors()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray210)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 상단 노치 컬러
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.presentTransparentNavigationBar()
        animate()
        
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

        serviceBannerCollectionView.delegate = self
        serviceBannerCollectionView.dataSource = self
        self.serviceBannerCollectionViewSetting()
        
        viewModel.articleLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag == true {
                    guard let model = self?.viewModel.articlePost else {
                        return
                    }
                    
                    // 이미지 깨졌을때 대비 할 것
                    if let image: String = model.images?[0] {
                        self?.artboardImage.kf.setImage(with: URL(string: image))
                    }
                    
                    if let title = model.boardTitle {
                        self?.artboardTitle.text = "\(title)"
                    }
                    
                    if let tags = model.tags {
                        var tagTitle: String = ""
                        for tag in tags {
                            tagTitle += "#\(tag) "
                        }
                        self?.artboardTag.text = "\(tagTitle)"
                    }
                    
                    if let nickname = model.nickname {
                        self?.artboardNickname.text = "\(nickname)"
                    }
                    
                    if let dpti = model.userDpti {
                        self?.artboardNickname.textColor = UIColor.dptiDarkColor(dpti)
                        self?.artboardProfile.image = UIImage(named: "Profile_\(dpti)")
                    }
                    
                    if let scrapCount: Int = model.scrapCount{
                        self?.artboardScrapCount.text = "\(scrapCount)"
                    }
                    
                    if let commentCount: Int = model.commentCount {
                        self?.artboardCommentCount.text = "\(commentCount)"
                    }
                }
            })
            .disposed(by: disposeBag)
        
        /*
         Service Banner
         */
        viewModel.serviceBannerLoading
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag == true {
                    self?.serviceBannerCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch segue.identifier {
        case "ServiceNoticeVC":
            let destination = segue.destination as! NoticeVC
            let index = sender as! Int
            print("link를 전달합니다.\(viewModel.serviceBannerUrlArr[index])")
            destination.urlRelay.accept(viewModel.serviceBannerUrlArr[index])
            
            break
            
        default:
            break
        }
    }
    

    @IBAction func pressedSettingBtn(_ sender: Any) {
        performSegue(withIdentifier: "testVC", sender: nil)
    }
    
    @IBAction func pressedProfileBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: .main)
        
        // 디모 아트보드로 이동
        let myProfileVC: MyProfileVC = storyboard.instantiateViewController(identifier: "MyProfileVC")
        let UID = viewModel.userUID
        myProfileVC.viewModel.profileSetting.accept(viewModel.myDptiType())
        myProfileVC.viewModel.userNickname = viewModel.myNickname()
        myProfileVC.viewModel.profileUID.accept(UID)
        
        self.navigationController?.pushViewController(myProfileVC, animated: true)
    }
    
    // 아티클에 숨겨진 버튼(?)을 클릭했을 경우
    @IBAction func pressedArtboardArticle(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Community", bundle: .main)
        
        // 디모 아트보드로 이동
        let articleDetailVC: ArticleDetailViewController = storyboard.instantiateViewController(identifier: "ArticleDetailVC")
        let articleModel = viewModel.articlePost
        
        if let boardId: String = articleModel?.boardId {
            articleDetailVC.viewModel.postUidRelay.accept(boardId)
        }
        
        if let title: String = articleModel?.boardTitle {
            articleDetailVC.viewModel.titleRelay.accept("\(title)")
        }
        
        if let backgroundImg: String = articleModel?.images?[0] {
            articleDetailVC.viewModel.thumbnailImageRelay.accept(URL(string: backgroundImg))
        }
        
        // TODO : Tags 수정
        if let tags: [String] = articleModel?.tags {
            var newTag: String = ""
            for tag in tags {
                newTag += "#\(tag)"
            }
//            articleDetailVC.viewModel.tagsRelay
        }

        self.navigationController?.pushViewController(articleDetailVC, animated: true)

    }
    
    // 최신 아트보드 + 더보기 클릭했을 경우
    @IBAction func pressedRecentArtboardTitleMoreBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Community", bundle: .main)
        
        // 디모 아트보드로 이동
        let communityVC: UIViewController = storyboard.instantiateViewController(identifier: "ArtboardMainVC")
        self.navigationController?.pushViewController(communityVC, animated: true)
    }
}

//MARK: - Service Banner

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 375나 414 둘 중 하나 카운트
        return self.viewModel.serviceBannerImgUrlString414.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceBannerCell", for: indexPath) as! ServiceBannerCell
        
        let index = indexPath.row
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        var imageUrlString: String?
        
        if deviceWidth <= 390 {
            imageUrlString = self.viewModel.serviceBannerImgUrlString375[index]
            print("390 이하 디바이스 사이즈 : \(deviceWidth)")
        } else {
            imageUrlString = self.viewModel.serviceBannerImgUrlString414[index]
            print("391 이상 디바이스 사이즈 : \(deviceWidth)")
        }
        
        guard let checkedImageStringUrl = imageUrlString else {
            return UICollectionViewCell()
        }
        
        cell.imageView.kf.setImage(with: URL(string: checkedImageStringUrl))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        performSegue(withIdentifier: "ServiceNoticeVC", sender: index)
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
