//
//  HistoryVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
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


//MARK: - TableView

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunitySearchHistoryCell", for: indexPath)

        return cell
    }
    
    
}

// MARK: -recommendCollectionView

extension HistoryVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityRecommendCell", for: indexPath)
        
        return cell
    }
    
    
}
