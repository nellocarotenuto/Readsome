//
//  ReaderController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 09/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit
import AVFoundation

class ReaderController : UIViewController {

    // Represents the user's settings
    let preferences = UserDefaults.standard
   
    let speech = AVSpeechSynthesizer()

    // Represents the text view where to display the scanned text
    @IBOutlet weak var textView : UITextView!
    
    // Represents the button used to trigger the text to speech
    @IBOutlet weak var textToSpeechButton : UIBarButtonItem!
    
    // Represents the scanned text to display
    var scannedText : ScannedText?
    
    var volume: Float!
    var pitch: Float!
    var rate: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update the view title
        self.title = scannedText!.title
        
        volume = preferences.float(forKey: "volume")
        pitch = preferences.float(forKey: "pitch")
        rate = preferences.float(forKey: "rate")
        
        // Build the text on user's preferences
        var attributes = [NSAttributedStringKey : Any]()
        
        // Setting the family and the size of the font
        let fontName = preferences.string(forKey : "font-family")!
        let fontSize = preferences.float(forKey : "text-size")
        
        let font : UIFont
        if preferences.bool(forKey : "font-bold") {
            var descriptor = UIFontDescriptor(name : fontName, size : CGFloat(fontSize))
            descriptor = descriptor.withSymbolicTraits(.traitBold)!
            
            font = UIFont(descriptor : descriptor, size : CGFloat(fontSize))
        } else {
            font = UIFont(name : fontName, size : CGFloat(fontSize))!
        }
        
        attributes[.font] = font
        
        // Setting the spacing between letters
        let letterSpacing = preferences.float(forKey : "letter-spacing")
        attributes[.kern] = letterSpacing
        
        
        // Setting the spacing between lines
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = CGFloat(preferences.float(forKey : "line-spacing"))
        attributes[.paragraphStyle] = paragraph
        
        let attributedString = NSMutableAttributedString(string : scannedText!.text!, attributes : attributes)
        
        // Get the dictionary of letters and extract the saved letter-color pairs
        let letters = preferences.dictionary(forKey : "letters") as! [String : NSData]
        let letterIndicies = Array(letters.keys)
        
        for letter in letterIndicies {
            let letterColor = NSKeyedUnarchiver.unarchiveObject(with : letters[letter]! as Data) as? UIColor
            let ranges = scannedText!.text!.ranges(of : letter)
            
            for range in ranges {
                attributedString.addAttribute(.foregroundColor, value : letterColor!, range : NSRange(range, in : textView.text))
            }
            
        }
        
        
        // Add some padding to the text container
        textView.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16)
        
        textView.attributedText = attributedString
    }

    @IBAction func textSpeech(_ sender: UIBarButtonItem) {
        
        if !speech.isSpeaking {
            let speechUtterance = AVSpeechUtterance(string: textView.text!)
            speechUtterance.pitchMultiplier = self.pitch
            speechUtterance.volume = self.volume
            speechUtterance.rate = self.rate
            
            speech.speak(speechUtterance)
            
        } else {
            speech.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
        if speech.isPaused {
            speech.continueSpeaking()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
