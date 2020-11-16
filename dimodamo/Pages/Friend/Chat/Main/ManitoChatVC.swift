//
//  ManitoChatVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import SideMenu

class ManitoChatVC: UIViewController {
    
    let viewModel = ManitoChatViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var textFieldView: UIView! {
        didSet {
            textFieldView.layer.cornerRadius = 24
            textFieldView.clipsToBounds = true
            textFieldView.layer.masksToBounds = false
            textFieldView.appShadow(.s20)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    /*
     ViewLoad
     */
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.white255)
        
        // 해당 유저 컬러로 변경할 것
        let userType = viewModel.yourType.value
        navigationController?.navigationBar.barTintColor = UIColor.dptiDarkColor(userType)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appColor(.textBig)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableviewSetting()
        
        viewModel.yourType
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { type in
                
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Button Binding
    
    // 검색버튼 눌렀을때
    @IBAction func pressedSearchBtn(_ sender: Any) {

    }
    
    // 서랍버튼 눌렀을때
    @IBAction func pressedArchiveBtn(_ sender: Any) {
//        let vc =
//        let menu = UISideMenuNavigationController(rootViewController: <#T##UIViewController#>)
//        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
//        let menu = storyboard.instantiateViewController(withIdentifier: "ArchiveVC") as! UISideMenuNavigationController
//        present(menu, animated: true, completion: nil)
    }
    
}


//MARK: - TableView

extension ManitoChatVC: UITableViewDelegate, UITableViewDataSource, TableReloadProtocol {
    
    func tableReload() {
        self.tableView.reloadData()
        print("reload합니다")
    }
    
    func tableviewSetting() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset.top = 16
//        tableView.estimatedRowHeight = 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as! YourChatCell
        let yourType = viewModel.yourType.value
        
        yourCell.profile.image = UIImage(named: "Profile_\(yourType)")
        yourCell.messageBox.layer.borderColor = UIColor.dptiDarkColor(yourType).cgColor
        yourCell.chagneColorGoodSign(yourType: "\(yourType)")
        yourCell.delegate = self
        
        return yourCell
    }
    
    
}
