//
//  TestCommunitySearchVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RealmSwift

import RxSwift
import RxCocoa

class TestCommunitySearchVC: UIViewController {
    
    let viewModel = CommunitySearchViewModel()
    var disposebag = DisposeBag()
    
    // 네비게이션 상단에 들어가는 서치바
    let searchController = UISearchController(searchResultsController: nil)
    // 나의 검색 기록
    @IBOutlet weak var searchHistoryTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.placeholder = "검색어를 입력해 주세요"
        self.searchController.searchBar.delegate = self
        
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
        
        /*
         Search History TableView
         */
        viewModel.searchHistoryRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.searchHistoryTableView.reloadData()
            })
            .disposed(by: disposebag)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func pressedHistoryClearBtn(_ sender: Any) {
        viewModel.allDeleteHistry()
    }
    
}


// MARK: - 나의 검색 기록

extension TestCommunitySearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableViewSetting() {
        searchHistoryTableView.rowHeight = 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchHistoryRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunitySearchHistoryCell", for: indexPath) as! SearchHistoryCell
        
        let index = indexPath.row
        let model = viewModel.searchHistoryRelay.value[index]
        
        cell.searchLabel.text = "\(model.keyword)"
        cell.dateLabel.text = "\(AppFormatGuide.unixtimestampConvert(unixTimestamp: model.searchTime))"
        
        return cell
    }
}

// MARK: - Search History ADD & Search Start

extension TestCommunitySearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        // 뷰모델에서 사용할 수 있으므로 저장
        viewModel.searchText = searchText
        
        // 검색하면 검색 히스토리 Realm에 추가
        viewModel.createHistroy(searchText: searchText)
        performSegue(withIdentifier: "CommunitySearchResult", sender: searchText)
    }
}
