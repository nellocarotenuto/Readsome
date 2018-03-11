//
//  ReaderController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 09/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit
import AVFoundation

class ReaderController : UIViewController, AVSpeechSynthesizerDelegate {

    // Represents the user's settings
    let preferences = UserDefaults.standard

    // Represents the text view where to display the scanned text
    @IBOutlet weak var textView : UITextView!
    
    // Represents the button used to trigger the text to speech
    @IBOutlet weak var textToSpeechButton : UIBarButtonItem!
    
    // Represents the scanned text to display
    var scannedText : ScannedText?
    
    let speech = AVSpeechSynthesizer()
    
    var volume: Float!
    var pitch: Float!
    var rate: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update the view title
        self.title = scannedText!.title
        
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
        
        // Prepare the text-to-speech component
        volume = preferences.float(forKey : "volume")
        pitch = preferences.float(forKey : "pitch")
        rate = preferences.float(forKey : "rate")
        
        speech.delegate = self
    }

    @IBAction func textSpeech(_ sender : UIBarButtonItem) {
        if speech.isSpeaking {
            // The text-to-speech component has been initialized..
            
            if speech.isPaused {
                // ..but no audio is being reproduced
                
                // Make it speak
                speech.continueSpeaking()
            } else {
                // ..and is actually speaking
                
                // Make it stop
                speech.pauseSpeaking(at : AVSpeechBoundary.immediate)
            }
        } else {
            // The text-to-speech component hasn't been initialized yet
            
            let speechUtterance = AVSpeechUtterance(string : textView.text!)
            speechUtterance.pitchMultiplier = self.pitch
            speechUtterance.volume = self.volume
            speechUtterance.rate = self.rate
            
            let lang = "en-US"
            speechUtterance.voice = AVSpeechSynthesisVoice(language : lang)
            speech.speak(speechUtterance)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        speech.stopSpeaking(at : .immediate)
    }

    func speechSynthesizer(_ synthesizer : AVSpeechSynthesizer, didFinish utterance : AVSpeechUtterance) {
        // Show a play button
        let playButton = UIBarButtonItem(barButtonSystemItem : .play, target : self, action: #selector(textSpeech(_ :)))
        
        textToSpeechButton = playButton
        navigationItem.rightBarButtonItem = playButton
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        // Show a play button
        let playButton = UIBarButtonItem(barButtonSystemItem : .play, target : self, action: #selector(textSpeech(_ :)))
        
        textToSpeechButton = playButton
        navigationItem.rightBarButtonItem = playButton
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Show a pause button
        let pauseButton = UIBarButtonItem(barButtonSystemItem : .pause, target : self, action: #selector(textSpeech(_ :)))
        
        textToSpeechButton = pauseButton
        navigationItem.rightBarButtonItem = pauseButton
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        // Show a pause button
        let pauseButton = UIBarButtonItem(barButtonSystemItem : .pause, target : self, action: #selector(textSpeech(_ :)))
        
        textToSpeechButton = pauseButton
        navigationItem.rightBarButtonItem = pauseButton
    }
    
    
}
