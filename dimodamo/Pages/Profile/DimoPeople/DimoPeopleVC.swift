//
//  DimoPeopleVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DimoPeopleVC: UIViewController {
    
    
    @IBOutlet weak var filterButtonContainer: UIView! {
        didSet {
            filterButtonContainer.layer.cornerRadius = 4
            filterButtonContainer.layer.masksToBounds = true
        }
    }
    
    /*
     Sahdow Setting
     */
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            for btn in buttons {
                btn.appShadow(.s4)
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
