//
//  TextSpeechController.swift
//  Readsome
//
//  Created by grassomiriam on 11/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit
import AVFoundation

class TextSpeechController: UITableViewController, AVSpeechSynthesizerDelegate {

    let preferences = UserDefaults.standard

    let speech = AVSpeechSynthesizer()
    
    @IBOutlet weak var textToSpeechBarButton: UIBarButtonItem!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBOutlet weak var pitchSlider: UISlider!
    
    @IBOutlet weak var sampleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the sliders to show the stored values
        volumeSlider.value = preferences.float(forKey: "volume")
        pitchSlider.value = preferences.float(forKey: "pitch")
        rateSlider.value = preferences.float(forKey: "rate")
        
        // Add some padding to the text container
        sampleTextView.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16)
        
        // Allow callbacks for speak changes
        speech.delegate = self
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

    @IBAction func testSpeech(_ sender: UIBarButtonItem) {
        if speech.isSpeaking {
            // The text-to-speech component has been initialized..
            
            if speech.isPaused {
                // ..but no audio is being reproduced
                
                // Make it speak
                speech.continueSpeaking()
            } else {
                // ..and is actually speaking
                
                // Make it stop
                speech.stopSpeaking(at : .immediate)
            }
        } else {
            // The text-to-speech component hasn't been initialized yet
            
            let speechUtterance = AVSpeechUtterance(string : sampleTextView.text!)
            speechUtterance.pitchMultiplier = preferences.float(forKey: "pitch")
            speechUtterance.volume = preferences.float(forKey: "volume")
            speechUtterance.rate = preferences.float(forKey: "rate")
            
            let lang = "en-US"
            speechUtterance.voice = AVSpeechSynthesisVoice(language : lang)
            speech.speak(speechUtterance)
        }
    }
    
    func speechSynthesizer(_ synthesizer : AVSpeechSynthesizer, didFinish utterance : AVSpeechUtterance) {
        // Show a play button
        let playButton = UIBarButtonItem(barButtonSystemItem : .play, target : self, action: #selector(testSpeech(_ :)))
        
        textToSpeechBarButton = playButton
        navigationItem.rightBarButtonItem = playButton
        
        // Enable the sliders
        rateSlider.isEnabled = true
        pitchSlider.isEnabled = true
        volumeSlider.isEnabled = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        // Show a play button
        let playButton = UIBarButtonItem(barButtonSystemItem : .play, target : self, action: #selector(testSpeech(_ :)))
        
        textToSpeechBarButton = playButton
        navigationItem.rightBarButtonItem = playButton
        
        // Enable the sliders
        rateSlider.isEnabled = true
        pitchSlider.isEnabled = true
        volumeSlider.isEnabled = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Show a pause button
        let stopButton = UIBarButtonItem(barButtonSystemItem : .stop, target : self, action: #selector(testSpeech(_ :)))
        
        textToSpeechBarButton = stopButton
        navigationItem.rightBarButtonItem = stopButton
        
        // Disable the sliders as we don't provide live tweaking
        rateSlider.isEnabled = false
        pitchSlider.isEnabled = false
        volumeSlider.isEnabled = false
    }
    
}
