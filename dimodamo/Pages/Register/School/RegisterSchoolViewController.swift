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
import RxRelay

import FirebaseStorage
import FirebaseAuth

import SearchTextField

class RegisterSchoolViewController: UIViewController {
    
    let schoolList: [String] = ["강릉원주대학교","강원대학교","강원대학교","경북대학교","경상대학교","공주대학교","군산대학교","금오공과대학교","목포대학교","목포해양대학교","부경대학교","부산대학교","서울대학교","순천대학교","안동대학교","전남대학교","전북대학교","제주대학교","창원대학교","충남대학교","충북대학교","한국교원대학교","한국체육대학교","한국해양대학교","한국교통대학교","경남과학기술대학교","서울과학기술대학교","한경대학교","한밭대학교","서울시립대학교","인천대학교","가야대학교","가톨릭대학교","감리교신학대학교","강남대학교","건국대학교","건양대학교","경기대학교","경남대학교","경동대학교","대구한의대학교","경성대학교","가천대학교","경일대학교","경주대학교","경희대학교","계명대학교","고려대학교","고신대학교","가톨릭관동대학교","광신대학교","광운대학교","광주가톨릭대학교","광주여자대학교","국민대학교","케이씨대학교","극동대학교","나사렛대학교","단국대학교","대구대학교","대구예술대학교","대구가톨릭대학교","세한대학교","대신대학교","대전가톨릭대학교","대전대학교","대진대학교","서울기독대학교","덕성여자대학교","동국대학교","동덕여자대학교","동서대학교","동신대학교","동아대학교","동양대학교","동의대학교","루터대학교","명지대학교","목원대학교","배재대학교","부산가톨릭대학교","부산외국어대학교","삼육대학교","상명대학교","상지대학교","서강대학교","서경대학교","서울신학대학교","서울여자대학교","서울장신대학교","서원대학교","선문대학교","성결대학교","성공회대학교","성균관대학교","성신여자대학교","세명대학교","세종대학교","수원가톨릭대학교","수원대학교","숙명여자대학교","순천향대학교","숭실대학교","신라대학교","아세아연합신학대학교","아주대학교","안양대학교","안양대학교","연세대학교","영남대학교","영남신학대학교","유원대학교","영산선학대학교","용인대학교","우석대학교","울산대학교","원광대학교","위덕대학교","을지대학교","을지대학교","이화여자대학교","인제대학교 ","인제대학교 ","인천가톨릭대학교","인천가톨릭대학교","인하대학교","장로회신학대학교","전주대학교","조선대학교","중부대학교","중앙대학교","중앙승가대학교","백석대학교","청주대학교","총신대학교","추계예술대학교","침례신학대학교","칼빈대학교","평택대학교","차의과학대학교","포항공과대학교","한국기술교육대학교","한국성서대학교","한국외국어대학교","한국항공대학교","한남대학교","한동대학교","한라대학교","한림대학교","한서대학교","한성대학교","한세대학교","한신대학교","한양대학교","서울한영대학교","한일장신대학교","협성대학교","호남대학교","호남신학대학교","호서대학교","홍익대학교","꽃동네대학교","남부대학교","예원예술대학교","목포가톨릭대학교","부산장신대학교","금강대학교","예수대학교","한국국제대학교","한북대학교","광주대학교","신경대학교","동명대학교","영산대학교","영산대학교","대전신학대학교","중원대학교","우송대학교","김천대학교","한려대학교","송원대학교","경운대학교","남서울대학교","초당대학교","한국산업기술대학교","제주국제대학교","창신대학교","신한대학교","울산과학기술원","공주교육대학교","광주교육대학교","대구교육대학교","부산교육대학교","서울교육대학교","경인교육대학교","전주교육대학교","청주교육대학교","춘천교육대학교","한국방송통신대학교","강원도립대학교","경남도립거창대학","경남도립남해대학","경북도립대학교","충북도립대학교","충남도립대학교","한국복지대학교","가톨릭상지대학교","군산간호대학교","거제대학교","경남정보대학교","호산대학교","경민대학교","영남외국어대학","경북전문대학교","경복대학교","경인여자대학교","서라벌대학교","계명문화대학교","계원예술대학교","광양보건대학교","광주보건대학교","구미대학교","서해대학","군장대학교","강동대학교","고구려대학교","기독간호대학교","전주기전대학","경북보건대학교","김포대학교","농협대학교","대경대학교","대구공업대학교","대구보건대학교","수성대학교","대구과학대학교","대동대학교","대림대학교","대원대학교","동서울대학교","대전보건대학교","우송정보대학","대전과학기술대학교","아주자동차대학","인천재능대학교","경북과학대학교","동남보건대학교","동부산대학교","동강대학교","동아방송예술대학교","동아보건대학교","동양미래대학교","동우대학","동원대학교","동의과학대학교","동주대학교","두원공과대학교","마산대학교","명지전문대학","목포과학대학교","문경대학교","배화여자대학교","백제예술대학교","부산경상대학교","부산여자대학교","부산과학기술대학교","부천대학교","삼육보건대학교","상지영서대학교","서영대학교","서울여자간호대학교","서울예술대학교","서일대학교","성덕대학교","성심외국어대학","송원대학","수원여자대학교","수원과학대학교","순천제일대학교","청암대학교","숭의여자대학교","신구대학교","신성대학교","신흥대학교","안동과학대학교","신안산대학교","안산대학교","연성대학교","동원과학기술대학교","여주대학교","연암공과대학교","연암대학교","영남이공대학교","강릉영동대학교","세경대학교","영진전문대학교","오산대학교","용인송담대학교","울산과학대학교","한국영상대학교","원광보건대학교","유한대학교","인덕대학교","인하공업전문대학","장안대학교","전남과학대학교","전주비전대학교","전북과학대학교","제주관광대학교","조선이공대학교","조선간호대학교","충북보건과학대학교","진주보건대학교","창원문성대학교","백석문화대학교","청강문화산업대학교","춘해보건대학교","대덕대학교","충청대학교","강원관광대학교","국제대학교","선린대학교","포항대학교","제주한라대학교","한림성심대학교","한양여자대학교","한영대학교","혜전대학교","경기과학기술대학교","부산예술대학교","전남도립대학교","송호대학교","한국관광대학교","서정대학교","송곡대학교","웅지세무대학교","김해대학교","한국승강기대학교","순복음총회신학교","영진사이버대학교","한국복지사이버대학","경희사이버대학교","국제사이버대학교","대구사이버대학교","부산디지털대학교","서울디지털대학교","서울사이버대학교","세종사이버대학교 ","한국열린사이버대학교","원광디지털대학교","고려사이버대학교","숭실사이버대학교","디지털서울문화예술대학교","한양사이버대학교","사이버한국외국어대학교","화신사이버대학교","글로벌사이버대학교","건양사이버대학교","한국과학기술원","광주과학기술원","대구경북과학기술원","한국예술종합학교","한국전통문화대학교","한국농수산대학","한국골프대학교"]
    
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!

    let isSelectedSchool = BehaviorRelay<Bool>(value: false)
    @IBOutlet weak var schoolTextField: SearchTextField! {
        didSet {
            schoolTextField.theme.font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14)
            schoolTextField.theme.fontColor = UIColor.appColor(.gray170)
            schoolTextField.theme.separatorColor = UIColor.appColor(.white235)
            schoolTextField.theme.cellHeight = 50
            schoolTextField.theme.bgColor = UIColor.appColor(.white255)

            schoolTextField.maxNumberOfResults = 4
            
            schoolTextField.userStoppedTypingHandler = {
                print("핸들렁아")
            }
            
            schoolTextField.itemSelectionHandler = { filteredResults, itemPosition in
                // Just in case you need the item position
                let item = filteredResults[itemPosition]
                print("Item at position \(itemPosition): \(item.title)")

                // Do whatever you want with the picked item
                self.schoolTextField.text = item.title
                self.viewModel?.school = item.title
                self.viewModel?.schoolRelay.accept(item.title)
                self.isSelectedSchool.accept(true)
            }
        }
    }
    @IBOutlet weak var schoolLine: UIView!
    
    
    var viewModel: RegisterViewModel?
    var disposeBag = DisposeBag()
    let imagePickerController = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 로드될 경우에 키보드 올라오도록
        schoolTextField.becomeFirstResponder()
        
//        schoolTextField.inlineMode = true
        schoolTextField.filterStrings(schoolList)
//        schoolTextField.delegate = self
    }
    
    


    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesisgn()
        self.view.layoutIfNeeded()
        
        schoolTextField.rx.text.orEmpty
            .map { $0 as String }
            .bind(to: self.viewModel!.schoolRelay)
            .disposed(by: disposeBag)
        
        viewModel?.schoolRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                print("newValue : \(newValue)")
                
                // 글이 수정될 때마다 새로 인증을 받아야 하므로, 이메일 중복 확인 해제
                if self?.viewModel?.school != newValue {
                    self?.viewModel?.school = newValue
                    // 새로운 정보가 들어올 때마다 nothing으로 변경
                    self?.isSelectedSchool.accept(false)
                    print("### 학교 선택함? \(self!.isSelectedSchool.value)")
                }
            })
            .disposed(by: disposeBag)
        
        isSelectedSchool
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag == true {
                    AppStyleGuide.systemBtnRadius16(btn: self!.finishBtn, isActive: true)
                    UIView.animate(withDuration: 0.5) {
                        self?.progress.setProgress(1, animated: true)
                    }
                } else {
                    AppStyleGuide.systemBtnRadius16(btn: self!.finishBtn, isActive: false)
                    UIView.animate(withDuration: 0.5) {
                        self?.progress.setProgress(0.8, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)

        
        
        // 터치하면 키보드 내려가도록
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
    }
    
    @IBAction func pressCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 다음으로
    @IBAction func pressFinishBtn(_ sender: Any) {
        if isSelectedSchool.value == false {
            let alert = AlertController(title: "학교를 입력해 주세요!", message: "만 19세 이상의 대학생만 가입 가능합니다", preferredStyle: .alert)
            alert.setTitleImage(UIImage(named: "alertError"))
            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            viewModel?.makeStructUserProfile()
            viewModel?.signUp()
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
    @objc func moveUpTextView(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.finishBtn?.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc func moveDownTextView() {
        self.finishBtn?.transform = .identity
    }
    
}

//MARK: - TextField

extension RegisterSchoolViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("호출")
        guard let schoolText: String = self.schoolTextField.text else {
            return false
        }
        for school in schoolList {
            if schoolText == school {
                print("\(school)을 선택하셨숩니다")
            }
        }
        return true
    }
}

//MARK: - ViewDesign
extension RegisterSchoolViewController {
    func viewDesisgn() {
        AppStyleGuide.systemBtnRadius16(btn: finishBtn, isActive: false)
    }
}

//MARK: - 학생증 인증

//extension RegisterSchoolViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @IBAction func pressSchoolCardBtn(_ sender: Any) {
//        self.imagePickerController.sourceType = .camera
//
//        print("SchoolIDRelay = \(viewModel?.schoolIdRelay.value), school = \(viewModel?.school.value)")
//
//        guard let schooldIdCount = viewModel?.schoolIdRelay.value.count else {
//            return
//        }
//        // 대학교정보와 학번정보 선택했을 경우에만
//        if schooldIdCount >= 7 && viewModel?.school.value.count != 0 {
//            self.present(self.imagePickerController, animated: true, completion: nil)
//        } else {
//            let alert = AlertController(title: "학교와 학번을 먼저 작성해주세요", message: "", preferredStyle: .alert)
//            alert.setTitleImage(UIImage(named: "alertError"))
//            let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//        }
//
//
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    // 사진 선택이 끝났을 경우
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//
//        guard let imageData = image.resize(withWidth: 400)?.jpeg(.lowest) else { return }
//        viewModel?.schoolCardImageData.accept(imageData)
//
//        // 이미지 저장이 끝났으면 스쿨 이미지 변경 및 버튼 변경
//        schoolCardBtn.setImage(UIImage(named: "schoolCardActive"), for: .normal)
//        viewModel?.schoolCertificationState = .submit
//    }
//
//    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
//
//        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
//        let cropped:UIImage = UIImage(cgImage:imageRef)
//        return cropped
//    }
//
//
//}
