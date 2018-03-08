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
        // CAREFUL: we've statically defined the cells, 5.0 is the font selection related one
        if indexPath.section == 5 && indexPath.row == 0 {
            // Define the title that will be shown in the newly-created picker
            let pickerTitle = NSLocalizedString("Font", comment: "Title for the font-family picker used inside text appearance preferences")
            
            // Get the preferred font from user defaults
            let selectedFont = preferences.string(forKey: "font-family")!
            
            // Define the list of available fonts
            let availableFonts = ["Helvetica Neue", "OpenDyslexic", "Times New Roman", "TestMeAlt02"]
            
            // Build the actual picker
            let actionSheetPicker = ActionSheetMultipleStringPicker(
                // Set the title
                title : pickerTitle,
                
                // Set the items inside the picker
                rows : [availableFonts],
                
                // Set the selected item
                initialSelection: [availableFonts.index(of: selectedFont)!],
                
                // Define what to do when the user taps "done"
                doneBlock: {
                    picker, indexes, values in
                    
                    // Get the selected item as a font name
                    let values = values as! [String]
                    let selectedFont = values[0]
                    
                    // Save the user preference
                    self.preferences.set(selectedFont, forKey: "font-family")
                    
                    // Update the sample text
                    self.updateSampleText()
                    
                    return
            },
            
            // Define what to do when the user taps "cancel"
            cancel: {
                _ in
                
                return
            },
            
            // Define the sender
            origin: fontFamilyCell)
            
            
            // Set the color of both "Cancel" and "Done" to our tint
            actionSheetPicker?.toolbarButtonsColor = view.tintColor
            
            // Actually show the picker
            actionSheetPicker?.show()
            
            // Don't forget to deselect the hit row
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
