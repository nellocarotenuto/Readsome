//
//  EditController.swift
//  Readsome
//
//  Created by Sorgente Fabrizio on 08/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit
import TesseractOCR
import GPUImage

class EditController : UITableViewController, UITextFieldDelegate, G8TesseractDelegate {

    @IBOutlet weak var scannedTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedImage : UIImage?
    var scannedText : String?
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.image = self.selectedImage
//      Create a new concurrent thread to perform the Image Recognition
        let concurrentQueue = DispatchQueue(label: "imageRecognition", attributes: .concurrent)
        concurrentQueue.async {
            self.performImageRecognition(self.selectedImage!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
//        if let scannedText = scannedText {
//            scannedTextView.text = scannedText
//        }
//
//        if let selectedImage = selectedImage {
//            imageView.contentMode = .scaleAspectFill
//            imageView.image = selectedImage
//        }
//
        // Hide the keyboard when tapping outside the field
        self.hideKeyboard()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem : .done, target : self, action : #selector(saveScannedText))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.delegate = self as? UITextFieldDelegate
        titleTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func saveScannedText() {
        if let selectedTitle = titleTextField.text, let scannedText = scannedTextView.text, !selectedTitle.isEmpty, !scannedText.isEmpty {
            ScannedTextManager.add(title : selectedTitle, text : scannedText, image : imageView.image!)
            navigationController?.popViewController(animated: true)
        } else {
            let title = NSLocalizedString("Incomplete fields", comment : "String used for the alert dialog shown when the user tries to add an empty scanned text or without a title")
            let message = NSLocalizedString("You have to select a title and keep some text in the scanned field", comment : "String presented in the alert dialog shown when the user tries to add an empty scanned text without a title.")
            
            // Set an "OK" action for the dialog
            let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
            alert.addAction(UIAlertAction(title: "OK", style : .default, handler : nil))
            
            // Show the alert dialog
            self.present(alert, animated : true, completion : nil)
        }
    }
    

    func performImageRecognition(_ image: UIImage) {
        
        let imagePreProcessed = self.processImage(inputImage: image)
        
        let tesseract = G8Tesseract(language: "eng", engineMode: .tesseractOnly)
        tesseract?.delegate = self
        
        // tesseract.engineMode = .tesseractCubeCombined
        
        tesseract?.pageSegmentationMode = G8PageSegmentationMode(rawValue: 1)!
        tesseract?.image = imagePreProcessed.g8_blackAndWhite()
        tesseract?.recognize()
        
        var text = tesseract?.recognizedText
        text = text?.components(separatedBy: NSCharacterSet.newlines).filter(){$0 != ""}.joined(separator: "\n")
        
//      Touching the UI in the main thread
        DispatchQueue.main.sync {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            self.scannedTextView.text = text
        }
    }
    
    
    func processImage(inputImage: UIImage) -> UIImage {
        
        var processedImage = inputImage
        
        let medianFilter = MedianFilter()
        var filteredImage = processedImage.filterWithOperation(medianFilter)
        let thresholdFilter = AdaptiveThreshold()
        thresholdFilter.blurRadiusInPixels = 2.0
        filteredImage = filteredImage.filterWithOperation(thresholdFilter)
        
        return filteredImage
    }
    

}
