//
//  RegisterSchoolViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterSchoolViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextTryBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var schoolCardBtn: UIButton!
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 다음에 할래요
    @IBAction func pressNextTryBtn(_ sender: Any) {
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

extension RegisterSchoolViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func pressSchoolCardBtn(_ sender: Any) {
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            schoolCardBtn.setImage(image, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
