//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var trueBtn: UIButton!
    @IBOutlet weak var falseBtn: UIButton!
    @IBOutlet weak var questionLable: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scoreText: UILabel!
    
    var quizBrain = QuizBrain()
    var scoreManager = ScoreManager()
    
    var timers = Timer()
    var progressPercentage: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        updateUI()
    }

    @IBAction func answerBtnPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle! // True, False
        let userGotItRight: Bool = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = UIColor.green
            scoreManager.addScore(Int(1))
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        quizBrain.questionNumberUpdate()
        
        // progressPercentage = Float(questionNumber) / Float(quiz.count)
        // print("questionNumber = \(questionNumber), quiz.count = \(quiz.count), percentage = \(Float(questionNumber) / Float(quiz.count))")
        
        timers = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
        // updateUI()
    }
    
    @objc func updateUI() {
        // questionLable.text = quiz[questionNumber].text
        questionLable.text = quizBrain.getQuestionText()
        // progressBar.setProgress(progressPercentage, animated: true)
        progressBar.progress = quizBrain.getProgress()
        scoreText.text = "Score : \(scoreManager.getScore())"
        
        trueBtn.backgroundColor = UIColor.clear
        falseBtn.backgroundColor = UIColor.clear
        
    }
    
}

