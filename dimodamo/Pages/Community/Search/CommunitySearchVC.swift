//
//  CommunitySearchVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/30.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class CommunitySearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldRoundView: UIView! {
        didSet {
            textFieldRoundView.layer.cornerRadius = 20
            textFieldRoundView.layer.borderWidth = 1.7
            textFieldRoundView.layer.borderColor = UIColor.appColor(.gray190).cgColor
            textFieldRoundView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressedSearchBtn(_ sender: Any) {
        print("검색")
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - TableView

extension CommunitySearchVC: UITableViewDelegate, UITableViewDataSource {
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

extension CommunitySearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityRecommendCell", for: indexPath)
        
        return cell
    }
    
    
}
