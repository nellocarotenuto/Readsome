//
//  TextSpeechController.swift
//  Readsome
//
//  Created by grassomiriam on 11/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class TextSpeechController: UITableViewController {

    let preferences = UserDefaults.standard

    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBOutlet weak var pitchSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        volumeSlider.maximumValue = 0.00
        volumeSlider.maximumValue = 1.00
        
        pitchSlider.minimumValue = 0.50
        pitchSlider.maximumValue = 2.00
        
        rateSlider.minimumValue = 0.00
        rateSlider.maximumValue = 1.00
        
        volumeSlider.value = preferences.float(forKey: "volume")
        pitchSlider.value = preferences.float(forKey: "pitch")
        rateSlider.value = preferences.float(forKey: "rate")
    }

    @IBAction func volumeChange(_ sender: UISlider) {
        let volume = sender.value
        preferences.set(volume, forKey: "volume")
    }
    
    @IBAction func pithChange(_ sender: UISlider) {
        let pitch = sender.value
        preferences.set(pitch, forKey: "pitch")
    }
    
    @IBAction func rateChange(_ sender: UISlider) {
        let rate = sender.value
        preferences.set(rate, forKey: "rate")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
