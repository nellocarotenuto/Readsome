//
//  EditController.swift
//  Readsome
//
//  Created by Sorgente Fabrizio on 08/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class EditController: UITableViewController {

    @IBOutlet weak var scannedTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : UIImage?
    var scannedText : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let scannedText = scannedText {
            scannedTextView.text = scannedText
        }
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
