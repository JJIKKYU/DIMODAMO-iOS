//
//  ViewController.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    
    
    var storyBrain = StoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
   }


    @IBAction func btnPressed(_ sender: UIButton) {
        
        if sender == choice1Button {
            storyBrain.setStoryNum(number: storyBrain.text[storyBrain.storyNumber].choice1Destination)
        } else {
            storyBrain.setStoryNum(number: storyBrain.text[storyBrain.storyNumber].choice2Destination)
        }
        
        updateUI()
    }
    
    func updateUI() {
        storyLabel.text = storyBrain.text[storyBrain.storyNumber].title
        choice1Button.setTitle(storyBrain.text[storyBrain.storyNumber].choice1, for: .normal)
        choice2Button.setTitle(storyBrain.text[storyBrain.storyNumber].choice2, for: .normal)
    }
}

