//
//  TextAppearanceController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 06/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class TextAppearanceController: UITableViewController {

    // Represents the user's settings
    let preferences = UserDefaults.standard
    
    
    // Resprents the UITextView used to display the sample text
    @IBOutlet weak var sampleTextView: UITextView!
    
    // Represents the UISlider used to adjust the size of the text
    @IBOutlet weak var textSizeSlider: UISlider!
    
    // Represents the UISlider used to adjust the spacing between the letters
    @IBOutlet weak var letterSpacingSlider: UISlider!
    
    // Represents the UISlider used to adjust the spacing between lines
    @IBOutlet weak var lineSpacingSlider: UISlider!
    
    // Represents the UISwitch used to make the text bold
    @IBOutlet weak var boldSwitch: UISwitch!
    
    // Represents the cell that triggers the font family picker
    @IBOutlet weak var fontFamilyCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the sliders to represent the saved value
        textSizeSlider.value = preferences.float(forKey: "text-size")
        letterSpacingSlider.value = preferences.float(forKey: "letter-spacing")
        lineSpacingSlider.value = preferences.float(forKey: "line-spacing")
        
        // Setting the switch status to represent the user's preference
        boldSwitch.setOn(preferences.bool(forKey: "font-bold"), animated: false)
        
        updateSampleText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    private func updateSampleText() {
        var attributes = [NSAttributedStringKey : Any]()
        
        // Setting the family and the size of the font
        let fontName = preferences.string(forKey: "font-family")!
        let fontSize = preferences.float(forKey: "text-size")
        
        let font : UIFont
        if preferences.bool(forKey: "font-bold") {
            var descriptor = UIFontDescriptor(name : fontName, size : CGFloat(fontSize))
            descriptor = descriptor.withSymbolicTraits(.traitBold)!
            
            font = UIFont(descriptor : descriptor, size: CGFloat(fontSize))
        } else {
            font = UIFont(name: fontName, size: CGFloat(fontSize))!
        }
        
        attributes[.font] = font
        
        // Setting the spacing between letters
        let letterSpacing = preferences.float(forKey: "letter-spacing")
        attributes[.kern] = letterSpacing
        
        
        // Setting the spacing between lines
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = CGFloat(preferences.float(forKey: "line-spacing"))
        attributes[.paragraphStyle] = paragraph
        
        
        // Actually update the TextView
        let sampleText = NSMutableAttributedString(string : sampleTextView.text, attributes : attributes)
        sampleTextView.attributedText = sampleText
    }
    
 
    @IBAction func textSizeChanged(_ sender: UISlider) {
        let textSize = sender.value
        
        preferences.set(textSize, forKey: "text-size")
        updateSampleText()
    }
    
    @IBAction func letterSpacingChanged(_ sender: UISlider) {
        let letterSpacing = sender.value
        
        preferences.set(letterSpacing, forKey: "letter-spacing")
        updateSampleText()
    }
    
    @IBAction func lineSpacingChanged(_ sender: UISlider) {
        let lineSpacing = sender.value
        
        preferences.set(lineSpacing, forKey : "line-spacing")
        updateSampleText()
    }
    
    @IBAction func weightChanged(_ sender: UISwitch) {
        preferences.set(sender.isOn, forKey: "font-bold")
        updateSampleText()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5 && indexPath.row == 0 {
            let pickerTitle = NSLocalizedString("Font", comment: "Title for the font-family picker used inside text appearance preferences")
            
            let selectedFont = preferences.string(forKey: "font-family")!
            let availableFonts = ["Helvetica Neue", "OpenDyslexic", "Times New Roman", "TestMeAlt02"]
            
            ActionSheetMultipleStringPicker.show(withTitle : pickerTitle, rows : [
                availableFonts,
                ], initialSelection: [availableFonts.index(of: selectedFont)!], doneBlock: {
                    picker, indexes, values in
                    
                    let values = values as! [String]
                    let selectedFont = values[0]
                    
                    self.preferences.set(selectedFont, forKey: "font-family")
                    
                    self.updateSampleText()
                    
                    return
            }, cancel: {
                _ in
                
                return
            }, origin: fontFamilyCell)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
