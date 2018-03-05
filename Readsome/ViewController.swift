//
//  ViewController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 05/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let selectedValue = sender.value*10
        
        sliderValue.font = sliderValue.font.withSize(CGFloat(selectedValue))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

