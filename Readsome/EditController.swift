//
//  EditController.swift
//  Readsome
//
//  Created by Sorgente Fabrizio on 08/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class EditController : UITableViewController {

    @IBOutlet weak var scannedTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : UIImage?
    var scannedText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scannedText = scannedText {
            scannedTextView.text = scannedText
        }
        
        if let selectedImage = selectedImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = selectedImage
        }
        
        // Hide the keyboard when tapping outside the field
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
