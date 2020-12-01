//
//  TestCommunitySearchVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RealmSwift

class TestCommunitySearchVC: UIViewController {
    
    // 네비게이션 상단에 들어가는 서치바
    let searchController = UISearchController(searchResultsController: nil)
    // 나의 검색 기록
    @IBOutlet weak var searchHistoryTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.placeholder = "검색어를 입력해 주세요"
        
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        navigationController?.view.backgroundColor = UIColor.appColor(.white255)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.view.setNeedsLayout() // force update layout
        self.navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetting()
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
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


// MARK: - 나의 검색 기록

extension TestCommunitySearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableViewSetting() {
        searchHistoryTableView.rowHeight = 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunitySearchHistoryCell", for: indexPath)
        
        return cell
    }
}
