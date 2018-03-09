//
//  EditController.swift
//  Readsome
//
//  Created by Sorgente Fabrizio on 08/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class EditController : UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var scannedTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : UIImage?
    var scannedText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        
        if let scannedText = scannedText {
            scannedTextView.text = scannedText
        }
        
        if let selectedImage = selectedImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = selectedImage
        }
        
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

}
