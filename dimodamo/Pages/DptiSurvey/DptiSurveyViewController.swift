//
//  DptiSurveyViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DptiSurveyViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet var answers : Array<UIButton>!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var cardTitle: UILabel!
    
    var cardNumber : Int = 1
    var questions : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewDesign()
        questionTitleParsing()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    func questionTitleParsing() {
        var surveyJson : [String : Any] = [:]
                
        let path = Bundle.main.path(forResource: "Survey", ofType: "json")
        if let data = try? String(contentsOfFile: path!).data(using: .utf8) {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            surveyJson = json
            questions = surveyJson["Question"] as! [String]
        }
    }
    
    func cardViewDesign() {
        // answer Color & Border & Border Color Init
        for answer in answers {
            answer.layer.cornerRadius = 16
            answer.layer.borderWidth = 2
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            answer.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        }
        
        card.layer.cornerRadius = 24
        card.addShadow(offset: CGSize(width: 0, height: 4), color: UIColor.black, radius: 16, opacity: 0.12)
    }
    
    @objc func startHighlight(sender : UIButton) {
        // next question card
        cardNumber += 1
        cardTitle.text = questions[cardNumber - 1]
        
        // all answer border color & text color init
        for answer in answers {
            answer.layer.borderColor = UIColor(named: "GRAY - 190")?.cgColor
            answer.setTitleColor(UIColor(named: "GRAY - 170"), for: .normal)
        }
        
        // select answer color change
        sender.layer.borderColor = UIColor(named: "YELLOW")?.cgColor
        sender.setTitleColor(UIColor(named: "YELLOW"), for: .normal)
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
