//
//  HotDimoPeopleVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class HotDimoPeopleVC: UIViewController {
    
    @IBOutlet weak var filterButtonContainer: UIView! {
        didSet {
            filterButtonContainer.layer.cornerRadius = 4
            filterButtonContainer.layer.masksToBounds = true
        }
    }
    
    let aspectWidth = (304 / 414) * UIScreen.main.bounds.width
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
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            let spacing = UIScreen.main.bounds.width / 25.875
            let cellWidthHeight = (Int(aspectWidth) - (Int(spacing) * 3)) / 4
            
            for btn in buttons {
                btn.appShadow(.s4)
                
                btn.widthAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
                btn.heightAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
                
                // 마지막 버튼은 필요 없음
                if btn.tag == 20 { continue }
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

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource =  self
        settingTableView()
        
        // Do any additional setup after loading the view.
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
