//
//  TextAppearanceController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 06/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class TextAppearanceController: UITableViewController {

    // Represents the user's settings
    let preferences = UserDefaults.standard
    
    
    // Resprents the UITextView used to display the sample text
    @IBOutlet weak var sampleTextView: UITextView!
    
    // Represents the UISlider used to adjust the size of the text
    @IBOutlet weak var textSizeSlider: UISlider!
    
    // Represents the UISlider used to adjust the spacing between the letters
    @IBOutlet weak var letterSpacingSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        preferences.set("Times New Roman", forKey: "font-family")
        preferences.set(15, forKey : "letter-spacing")
        updateSampleText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    private func updateSampleText() {
        var attributes = [NSAttributedStringKey : Any]()
        
        // Setting the family and the size of the font
        let fontName = preferences.string(forKey: "font-family")
        let fontSize = preferences.float(forKey: "text-size")
        
        let font = UIFont(name: fontName!, size: CGFloat(fontSize))
        attributes[.font] = font
        
        // Setting the spacing between letters
        let letterSpacing = preferences.float(forKey: "letter-spacing")
        attributes[.kern] = letterSpacing
        
        
        // Actually update the TextView
        let sampleText = NSMutableAttributedString(string : sampleTextView.text, attributes : attributes)
        sampleTextView.attributedText = sampleText
    }
    

    @IBAction func textSizeChanged(_ sender: UISlider) {
        let textSize = sender.value
        
        preferences.set(textSize, forKey: "text-size")
        updateSampleText()
    }
    
    @IBAction func letterSpacingChanges(_ sender: UISlider) {
        let letterSpacing = sender.value
        
        preferences.set(letterSpacing, forKey: "letter-spacing")
        updateSampleText()
    }
    
    
    
}
