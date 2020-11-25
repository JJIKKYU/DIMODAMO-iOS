//
//  ProfileSearchVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/24.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ProfileSearchVC: UIViewController {
    
    let viewModel = ProfileSearchViewModel()
    var disposeBag = DisposeBag()
    var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    override func loadView() {
        super.loadView()
        setColors()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.placeholder = "검색어를 입력해 주세요"

        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        navigationController?.view.backgroundColor = UIColor.appColor(.white255)
        animate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func setColors(){
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray190)
        navigationController?.navigationBar.barTintColor = .white
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setColors()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        self.settingTableView()
        
        viewModel.searchResultsRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                if results.count > 0 {
                    print("받아옵니다. : \(results)")
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)

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

// MARK: - Serach Controlelr Result

extension ProfileSearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Searching with: " + (searchController.searchBar.text ?? ""))
        let searchText = (searchController.searchBar.text ?? "")
        self.viewModel.currentSearchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("검색합니다.")
        
        self.viewModel.search()
    }
}


// MARK: - Result Table View

extension ProfileSearchVC: UITableViewDelegate, UITableViewDataSource {
    func settingTableView() {
        tableView.rowHeight = 242
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResultsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("\(indexPath.row)를 그립니다.")
        let cell = tableView.dequeueReusableCell(withIdentifier: "DimoTableViewCell", for: indexPath) as! DamoPeopleCell
        
        let index = indexPath.row
        let model = viewModel.searchResultsRelay.value[index]
        
        
        if let nickname: String = model.nickName {
            cell.nickname?.text = "\(nickname)"
        }

        if let dptiType: String = model.dpti {
            cell.profile.image = UIImage(named: "Profile_\(dptiType)")
            cell.topContainer.backgroundColor = UIColor.dptiDarkColor("\(dptiType)")
            cell.topContainerBottomView.backgroundColor = UIColor.dptiDarkColor("\(dptiType)")
            cell.backgroundPattern.image = viewModel.getBackgroundPattern(dpti: "\(dptiType)")
            cell.typeImage.image = UIImage.dptiProfileTypeIcon("\(dptiType)", isFiiled: true)
        }

        if let interestArr: [String] = model.interest {
            for (index, tag) in cell.tags.enumerated() {
                tag.text = Interest.getWordFromString(from: interestArr[index])
            }
        }
        
        
        return cell
    }
}
