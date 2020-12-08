//
//  ReportMainVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ReportMainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 종료 버튼을 눌렀을 경우
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 신고 내용 작성을 끝내고, 완료 버튼을 누를 경우
    @IBAction func pressedApplyBtn(_ sender: Any) {
        // 신고 로직 호출
    }
    
    
}

// MARK: - TableView

extension ReportMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
        
        return cell
    }
    
    
}
