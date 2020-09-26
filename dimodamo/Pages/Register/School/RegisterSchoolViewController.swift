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

import FirebaseStorage

class RegisterSchoolViewController: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextTryBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var schoolCardBtn: UIButton!
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    let imagePickerController = UIImagePickerController()
    
    private let storage = Storage.storage().reference()
    
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let imageData = image.resize(withWidth: 400)?.jpeg(.lowest) else { return }
        
//        schoolCardBtn.setImage(image, for: .normal)
        
        storage.child("images/file.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.storage.child("images/file.png").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                print("DownloadURL : \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
        
        
        
        
    }
}
