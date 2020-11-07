//
//  DimoPeopleVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DimoPeopleVC: UIViewController {
    
    let aspectWidth = (304 / 414) * UIScreen.main.bounds.width
    let spacing: CGFloat = UIScreen.main.bounds.width / 26
    
    @IBOutlet var stackViews: [UIStackView]! {
        didSet {
            for stackView in stackViews {
//                stackView.widthAnchor.constraint(equalToConstant: aspectWidth).isActive = true
                stackView.spacing = spacing
                
            }
            
        }
    }
    
    @IBOutlet weak var filterButtonContainer: UIView! {
        didSet {
            filterButtonContainer.layer.cornerRadius = 4
            filterButtonContainer.layer.masksToBounds = true
        }
    }
    
    /*
     Sahdow Setting / Width Height Setting
     */
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            let cellWidthHeight = (aspectWidth - spacing * 3) / 4
            
            print("########### \(spacing)")
            print("########### aspect \(aspectWidth)")
            print("########## cellWidthHeight \(cellWidthHeight)")
            
            
            
            
            for btn in buttons {
                
                btn.appShadow(.s4)
                
                // 마지막 버튼일 경우
//                if btn.tag == 20 {
//                    let height = cellWidthHeight * 0.4375
//
//                    btn.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
//                } else {
//                    btn.widthAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
//                    btn.heightAnchor.constraint(equalToConstant: CGFloat(cellWidthHeight)).isActive = true
//                }
                
                
                
                
                
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
        tableView.dataSource = self
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

extension DimoPeopleVC: UITableViewDelegate, UITableViewDataSource {
    func settingTableView() {
        tableView.rowHeight = 194
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DimoTableViewCell", for: indexPath)
        
        return cell
    }
    
    
}
