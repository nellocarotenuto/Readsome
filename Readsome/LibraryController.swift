//
//  LibraryController.swift
//  Readsome
//
//  Created by Sorgente Fabrizio on 08/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit
import TesseractOCR
import Photos
import AVFoundation
import CoreImage
import GPUImage


class LibraryController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {

    // Stores the collection of scanned texts
    var scannedTexts : [ScannedText]?
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        // Define the picker title
        let imagePickerTitle = NSLocalizedString("Upload a photo from..", comment : "String used as title for the picker that allows image selection from gallery or camera")
        
        // Build the picker as an ActionSheet
        let imagePickerActionSheet = UIAlertController(title : imagePickerTitle, message : nil, preferredStyle : UIAlertControllerStyle.actionSheet)
        
        // Set the camera action only if it is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Define the camera name
            let camera = NSLocalizedString("Camera", comment : "String that represents the camera name")
            
            let cameraButton = UIAlertAction(title : camera, style : .default, handler : {
                alert in
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true

                
                self.present(imagePicker, animated : true, completion : nil)
            })
            
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        
        // Define the gallery name
        let gallery = NSLocalizedString("Gallery", comment : "String that represents the gallery name")
        
        let libraryButton = UIAlertAction(title : gallery, style : .default) {
            alert in
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated : true, completion : nil)
        }
        
        imagePickerActionSheet.addAction(libraryButton)
        
        // Define the string used for cancel action
        let cancelName = NSLocalizedString("Cancel", comment : "String used for cancel actions")
        
        let cancelButton = UIAlertAction(title : cancelName, style : .cancel) {
            alert in
            
        }
        
        imagePickerActionSheet.addAction(cancelButton)
        imagePickerActionSheet.view.layoutIfNeeded()
        // It displays the action sheet to the user after tapping the PHOTO CAMERA button in navigation bar
        
        
        if let popoverController = imagePickerActionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        present(imagePickerActionSheet, animated : true, completion : nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated : true, completion : nil)
    }
    
    
    func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info : [String : Any]) {

        
        // The image comes from the camera
        if let selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage {
            picker.dismiss(animated: true, completion:{
                // Instantiate the view controller delegated to show the results
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let editController = storyBoard.instantiateViewController(withIdentifier: "editController") as! EditController
                editController.selectedImage = selectedPhoto

                // Show the controller
                self.navigationController?.pushViewController(editController, animated: true)

            })
             }
        
        // The image comes from the gallery
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated : true, completion : {
                // Instantiate the view controller delegated to show the results
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let editController = storyBoard.instantiateViewController(withIdentifier: "editController") as! EditController
                editController.selectedImage = selectedPhoto
                
                // Show the controller
                self.navigationController?.pushViewController(editController, animated: true)
                
            })
        }
        
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView : UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView : UITableView, numberOfRowsInSection section : Int) -> Int {
        return ScannedTextManager.loadAll().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the scanned text to display
        let scannedText = ScannedTextManager.load(by : indexPath.row)
        
        // Get the delegated cell and cast it to a LibraryCell
        let cell = tableView.dequeueReusableCell(withIdentifier : "libraryCell", for : indexPath) as! LibraryCell

        // Set the label and the image to what's inside the scanned text to display
        cell.scannedImage.image = UIImage(data: scannedText.image! as Data)
        cell.titleLabel.text = scannedText.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            // Programmatically set the name of the section that displays all the scans
            case 0 : return NSLocalizedString("Scans", comment: "String used as header of the scans section in the main screen")
            
            default : return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ScannedTextManager.delete(by : indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        ScannedTextManager.move(from : fromIndexPath.row, to : to.row)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScannedText" {
            let destination = segue.destination as! ReaderController
            
            destination.scannedText = ScannedTextManager.load(by : (tableView.indexPathForSelectedRow?.row)!)
        }
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        scannedTexts = ScannedTextManager.loadAll()
        tableView.reloadData()
    }
    
}
