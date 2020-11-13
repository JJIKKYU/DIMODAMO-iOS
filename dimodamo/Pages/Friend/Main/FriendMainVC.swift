//
//  FriendMainViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FriendMainVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var underBar: UIView! {
        didSet {
            underBar.layer.cornerRadius = underBar.layer.frame.height / 2
            underBar.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//MARK: - 버튼 클릭했을 때 이벤트 처리
    
    /*
     우측 소팅 버튼을 클릭했을 때
     */
    @IBAction func pressedSortingBtn(_ sender: Any) {
    }
    
    /*
     내 마니또 버튼 클릭했을 때
     */
    @IBAction func pressedManitoBtn(_ sender: Any) {
    }
    
    /*
     쪽지함 버튼을 클릭했을 때
     */
    @IBAction func pressedMessageBtn(_ sender: Any) {
    }
}
