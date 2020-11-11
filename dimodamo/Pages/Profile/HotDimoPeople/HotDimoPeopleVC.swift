//
//  HotDimoPeopleVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class HotDimoPeopleVC: UIViewController {
    
    let viewModel = HotDimoPeopleViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableViewTopContainer: UIView!
    @IBOutlet weak var filterButtonContainer: UIView! {
        didSet {
            filterButtonContainer.layer.cornerRadius = 4
            filterButtonContainer.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var filterBtnArrow: UIImageView!
    @IBOutlet var stackViews: [UIStackView]! {
        didSet {
            for stackView in stackViews {
                stackView.widthAnchor.constraint(equalToConstant: aspectWidth).isActive = true
                
            }
            
        }
    }
    
    /*
     Sahdow Setting
     */
    let aspectWidth = (304 / 414) * UIScreen.main.bounds.width
    let spacing: CGFloat = UIScreen.main.bounds.width / 26
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            let cellWidthHeight = (aspectWidth - spacing * 3) / 4
            
            for btn in buttons {
                
                btn.appShadow(.s4)
                
                // 마지막 버튼일 경우
                if btn.tag == 20 {
                    let height = cellWidthHeight * 0.4375

                    btn.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                } else {
                    btn.widthAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
                    btn.heightAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
                }
                
            }
        }
    }
    
    @IBOutlet weak var filterContainer: UIView! {
        didSet {
//            filterContainer.isHidden = true
        }
    }
    
    /*
     mainTableView
     */
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray190)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource =  self
        settingTableView()
        
        for index in 0...8 {
            buttons[index].rx.tap
                .scan(false) { lastValue, _ in
                    return !lastValue
                }
                .bind(to: buttons[index].rx.isSelected)
                .disposed(by: disposeBag)
        }
        
    }
    

    @IBAction func pressedFilterBtn(_ sender: Any) {
        print("pressedFilterBtn")
        
        switch viewModel.isTurnOnFilter {
        
        // 이미 필터가 켜져있을 경우
        case true:
            self.filter(isTurnOn: false)
            break
            
        // 필터가 꺼져있을 경우
        case false:
            self.filter(isTurnOn: true)
            break
        }
        
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

//MARK: - FilterBtnAction
extension HotDimoPeopleVC {
    func filter(isTurnOn: Bool) {
        let turnOnHeight: CGFloat = 200
        let turnOffHeight: CGFloat = 460
        
        var newHaderViewFrame = tableView.tableHeaderView!.frame
        switch isTurnOn {
        case true:
            newHaderViewFrame.size.height = turnOnHeight
            self.filterContainer.isHidden = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.filterBtnArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            print("true")
            break
            
        case false:
            newHaderViewFrame.size.height = turnOffHeight
            self.filterContainer.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.filterBtnArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            }
            
            print("false")
            break
        }
        
        let tableHeaderView = tableView.tableHeaderView
        
        // 애니메이션을 넣으려면 여기로
        tableHeaderView!.frame = newHaderViewFrame
        self.tableView.tableHeaderView = tableHeaderView
        
        viewModel.isTurnOnFilter = isTurnOn
    }
}

//MARK: - TableView

extension HotDimoPeopleVC: UITableViewDelegate, UITableViewDataSource {
    func settingTableView() {
        tableView.rowHeight = 242
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotDimoPeopleCell", for: indexPath)
        
        return cell
    }
    
}
