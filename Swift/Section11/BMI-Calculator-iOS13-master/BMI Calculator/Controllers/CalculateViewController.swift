//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()

    @IBOutlet weak var heightBar: UISlider!
    @IBOutlet weak var weightBar: UISlider!
    @IBOutlet weak var heightLable: UILabel!
    @IBOutlet weak var weightLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func heightBarChanged(_ sender: UISlider) {
        let value = String(format: "%.2f", sender.value)
        heightLable.text = "\(value)m"
    }
    
    @IBAction func weightBarChanged(_ sender: UISlider) {
        let value = String(Int(sender.value))
        weightLable.text = "\(value)kg"
    }
    
    @IBAction func calcualtedPressed(_ sender: UIButton) {
        let height = heightBar.value
        let weight = weightBar.value
        
        calculatorBrain.calculateBMI(height: height, weight: weight)
        
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()
        }
    }
}

