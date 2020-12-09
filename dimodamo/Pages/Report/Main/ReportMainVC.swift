//
//  ReportMainVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ReportMainVC: UIViewController {
    
    let viewModel = ReportMainViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet var topView_user: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet var topView_post: UIView!
    @IBOutlet weak var postProfile: UIImageView!
    @IBOutlet weak var postNickname: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet var topView_comment: UIView!
    @IBOutlet weak var commentProfile: UIImageView!
    @IBOutlet weak var commentNickname: UILabel!
    @IBOutlet weak var commentTitle: UITextView!
    @IBOutlet weak var commentCreateAt: UILabel!
    
    /*
     신고 내용
     */
    @IBOutlet var reportDescriptionView: UIView!
    @IBOutlet weak var reportDescriptionContainerView: UIView! {
        didSet {
            reportDescriptionContainerView.layer.cornerRadius = 9
            reportDescriptionContainerView.layer.masksToBounds = true
            
            reportDescriptionContainerView.layer.borderWidth = 1.5
            reportDescriptionContainerView.layer.borderColor = UIColor.appColor(.white245).cgColor
        }
    }
    @IBOutlet weak var reportDescriptionTextField: UITextView! {
        didSet {
            reportDescriptionTextField.delegate = self
            reportDescriptionTextField.text = "내용을 입력해 주세요"
            reportDescriptionTextField.textColor = UIColor.appColor(.gray210)
            reportDescriptionTextField.textContainerInset = .zero
            reportDescriptionTextField.textContainer.lineFragmentPadding = 0
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    /*
     상단바 컬러
     */
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
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.white255)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(reportDescriptionView)
        self.tableView.tableFooterView = reportDescriptionView
        
        viewModel.reportState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if value == .complete {
                    let alert = AlertController(title: "신고가 완료되었습니다", message: "빠른 시일 내에 처리하겠습니다", preferredStyle: .alert)
                    alert.setTitleImage(UIImage(named: "alertComplete"))
                    let action = UIAlertAction(title: "확인", style: .default) { action in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    action.setValue(UIColor.appColor(.green2), forKey: "titleTextColor")
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                }
                else if value == .fail {
                    
                }
                else {
                    
                }
            })
            .disposed(by: disposeBag)
        
        /*
         Keyboard
         */
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /*
     Table Header View를 신고 유형에 맞추어서 세팅
     */
    func topViewSetting(reportType: ReportType, profileImage: UIImage, nickname: String, text: String, createAt: String,                        userUid: String, contentUid: String, targetBoard: TargetBoard) {
        print("전달 받은 유저 UID: \(userUid), 콘텐츠 UID: \(contentUid)")
        
        switch reportType {
        case .post:
            self.view.addSubview(topView_post)
            self.tableView.tableHeaderView = topView_post
            
            postProfile.image = profileImage
            postNickname.text = nickname
            postTitle.text = text
            
            // 신고 당하는 콘텐츠 (댓글) UID
            viewModel.contentUID = contentUid
            // 신고 당하는 유저 UID
            viewModel.targetUserUID = userUid
            // 신고 보드 네임
            viewModel.currentReportBoard = targetBoard
            
            viewModel.currentReportType = .post
            
            break
            
        case .comment:
            self.view.addSubview(topView_comment)
            self.tableView.tableHeaderView = topView_comment
            
            commentProfile.image = profileImage
            commentNickname.text = nickname
            commentTitle.text = text
            commentCreateAt.text = createAt
            
            // 신고 당하는 콘텐츠 (댓글) UID
            viewModel.contentUID = contentUid
            // 신고 당하는 유저 UID
            viewModel.targetUserUID = userUid
            // 신고 보드 네임
            viewModel.currentReportBoard = targetBoard
            
            viewModel.currentReportType = .comment
            
            break
            
        case .user:
            self.view.addSubview(topView_user)
            self.tableView.tableHeaderView = topView_user
            
            userProfile.image = profileImage
            
            // 신고 당하는 유저 UID
            viewModel.targetUserUID = userUid
            // 신고 보드 네임
            viewModel.currentReportBoard = targetBoard

            viewModel.currentReportType = .user
            
            break
        }
        
        self.tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 종료 버튼을 눌렀을 경우
    @IBAction func pressedCloseBtn(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // 신고 내용 작성을 끝내고, 완료 버튼을 누를 경우
    @IBAction func pressedApplyBtn(_ sender: Any) {
        /*
         신고가 이미 진행한 건지 체크
         */
        if viewModel.alreadyPrevReport {
            let alert = AlertController(title: "이미 신고를 진행했어요", message: "신고는 한 번만 가능합니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive) { action in
                // 바깥으로
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        /*
         아래부터 신고 로직 진행
         */
        
        // 신고 버튼을 누를 때만 텍스트 동기화
        viewModel.reportText = self.reportDescriptionTextField.text
//        print(viewModel.reportText?.count)
        
        // 신고 사유를 선택하지 않았을 경우
        if !viewModel.isSelectedReportValue {
            let alert = AlertController(title: "사유를 선택해 주세요", message: "", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 신고 내용을 미작성 했을 경우
        if !viewModel.isWriteReportText {
            let alert = AlertController(title: "내용을 입력해 주세요", message: "", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        // 신고 내용을 작성했을 경우
        else {
            let alert = AlertController(title: "정말 신고하시겠어요?", message: "", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive) { action in
                print("신고 로직을 진행합니다.")
                self.viewModel.report()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}

// MARK: - TableView

extension ReportMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        let index = indexPath.row
        
        cell.titleLabel.text = viewModel.reportArr[index]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택했습니다. \(indexPath.row), 신고 타입 : \(viewModel.reportArr[indexPath.row])")
        
        // 선택할 때 마다, 나머지 버튼들 비활성화
        for cell in tableView.visibleCells {
            let reportCell = cell as! ReportCell
            reportCell.unselectedBtn()
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! ReportCell
        cell.selectBtn()
        viewModel.selectedReportValue = viewModel.reportArr[indexPath.row]
    }
    
}

// MARK: - TextField & Keyboard

extension ReportMainVC: UITextFieldDelegate, UITextViewDelegate {
    // 내용 본문에 Height에 맞게 조절하기 위해
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    // 키보드 업, 다운 관련
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc func moveDownTextView() {
        self.tableView.contentInset.bottom = 0
    }
    
    
    // TextView (메인) placehorder logic
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(.gray210) {
            textView.text = nil
            textView.textColor = UIColor.appColor(.gray170)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해 주세요"
            textView.textColor = UIColor.appColor(.gray210)
        }
    }
}
