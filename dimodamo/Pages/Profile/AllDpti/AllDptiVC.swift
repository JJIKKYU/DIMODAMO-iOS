//
//  AllDptiVC.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class AllDptiVC: UIViewController {

    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension AllDptiVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DptiCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    
}
