//
//  TextHighlightingController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 07/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class TextHighlightingController  : UITableViewController, UITextFieldDelegate {

    let preferences = UserDefaults.standard

    // Represent the buttons used to change the color to assign to the text
    @IBOutlet weak var redButton : UIButton!
    @IBOutlet weak var orangeButton : UIButton!
    @IBOutlet weak var yellowButton : UIButton!
    @IBOutlet weak var greenButton : UIButton!
    @IBOutlet weak var cyanButton : UIButton!
    @IBOutlet weak var blueButton : UIButton!
    @IBOutlet weak var purpleButton : UIButton!
    @IBOutlet weak var magentaButton : UIButton!
    
    
    // Represents the field in which the user enters the text to highlight
    @IBOutlet weak var textField: UITextField!
    
    
    // Represent the user selections
    var previousText : String?
    var textToHighlight : String?
    var selectedColor : UIColor?
    var selectedButton : UIButton?
    
    
    @IBAction func colorChanged(_ sender : UIButton) {
        // Do not perform any action if the button clicked is the one already selected
        guard sender != selectedButton else {
            return
        }
        
        // Reset the status of the currently selected button
        if let selectedColor = selectedColor, let selectedButton = selectedButton {
            selectedButton.backgroundColor = selectedColor
            selectedButton.setTitle("", for : .normal)
        }
        
        // Update the selected button
        selectedButton = sender
        selectedButton?.setTitle("✓", for : .normal)
        selectedColor = sender.backgroundColor
        
        // Displaythe button as darker and ticked
        let selectedColorDarken = selectedColor?.darker(by : 25)
        sender.backgroundColor = selectedColorDarken
    }

    @IBAction func textChanged(_ sender : UITextField) {
        // Set the text to highlight to the one inside the text view
        textToHighlight = sender.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        
        // Set up buttons background colors
        redButton.backgroundColor = UIColor.red
        orangeButton.backgroundColor = UIColor.orange
        yellowButton.backgroundColor = UIColor.yellow
        greenButton.backgroundColor = UIColor.green
        cyanButton.backgroundColor = UIColor.cyan
        blueButton.backgroundColor = UIColor.blue
        purpleButton.backgroundColor = UIColor.purple
        magentaButton.backgroundColor = UIColor.magenta
        
        // Update the text to highlight
        if let textToHighlight = textToHighlight {
            previousText = textToHighlight
            textField.text = textToHighlight
        }
        
        // Update the color used for highlighting
        if let selectedColor = selectedColor {
            switch selectedColor {
                case .red : colorChanged(redButton)
                case .orange : colorChanged(orangeButton)
                case .yellow : colorChanged(yellowButton)
                case .green : colorChanged(greenButton)
                case .cyan : colorChanged(cyanButton)
                case .blue : colorChanged(blueButton)
                case .purple : colorChanged(purpleButton)
                case .magenta : colorChanged(magentaButton)
                default : break
            }
        }
        
        // Hide the keyboard when tapping outside the field
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.delegate = self as? UITextFieldDelegate
        textField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func textWillBeSaved(_ sender : Any) {
        // Only save the text if both text field and a color button are selected
        if let textToHighlight = textToHighlight, let selectedColor = selectedColor, !textToHighlight.isEmpty {
            // Get the dictionary from the user details
            var letters = preferences.dictionary(forKey : "letters") as! [String : NSData]
            
            // Remove the old entry if the text has changed
            if let previousText = previousText {
                letters.removeValue(forKey: previousText)
            }
            
            // Insert the entry in the dictionary and save it
            letters[textToHighlight] = NSKeyedArchiver.archivedData(withRootObject : selectedColor) as NSData
            preferences.set(letters, forKey : "letters")
            
            // Get back to the previous screen
            self.navigationController?.popViewController(animated : true)
        } else {
            let title = NSLocalizedString("Incomplete fields", comment : "String used for the alert dialog shown when the user tries to add a text to highlight without setting either text or color")
            let message = NSLocalizedString("You have to select both text and color.", comment : "String presented in the alert dialog shown when the user tries to add a text to highlight without setting either text or color")
            
            // Set an "OK" action for the dialog
            let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
            alert.addAction(UIAlertAction(title: "OK", style : .default, handler : nil))
            
            // Show the alert dialog
            self.present(alert, animated : true, completion : nil)
        }
        
    }
    
    

}
