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

class ManitoChatVC: UIViewController {
    
    let viewModel = ManitoChatViewModel()
    var disposeBag = DisposeBag()

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
}


//MARK: - TableView

extension ManitoChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableviewSetting() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset.top = 16
//        tableView.estimatedRowHeight = 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourChat", for: indexPath) as! YourChatCell
        
        let type = viewModel.yourType.value
        
        cell.profile.image = UIImage(named: "Profile_\(type)")
        cell.messageBox.layer.borderColor = UIColor.dptiDarkColor(type).cgColor
        
        return cell
    }
    
    
}
