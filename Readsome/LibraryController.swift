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


class LibraryController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate{

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
//        TODO NSLOCALIZEDSTRING
        
        let imagePickerActionSheet = UIAlertController(title: "Upload a photo from...", message: nil, preferredStyle: .actionSheet)
        
        //        TODO NSLOCALIZEDSTRING
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            })
            imagePickerActionSheet.addAction(cameraButton)
        }
        //        TODO NSLOCALIZEDSTRING
        let libraryButton = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        //        TODO NSLOCALIZEDSTRING
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in }
        imagePickerActionSheet.addAction(cancelButton)
        imagePickerActionSheet.view.layoutIfNeeded()
        //It displays the action sheet to the user after tapping the PHOTO CAMERA button in navigation bar
        present(imagePickerActionSheet, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        //        photoUmageView.image = selectedPhoto
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            photoUmageView.contentMode = .scaleAspectFit
//            photoImageView.image = selectedPhoto
            picker.dismiss(animated: true, completion : {
                
                let recognizedText = self.performImageRecognition((selectedPhoto))
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let editController = storyBoard.instantiateViewController(withIdentifier: "editController") as! EditController
                
                
                
                editController.selectedImage = selectedPhoto
                editController.scannedText = recognizedText
                
                self.navigationController?.pushViewController(editController, animated: true)
            })
        }
        
        if let selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage {
//            photoUmageView.contentMode = .scaleAspectFit
//            photoImageView.image = selectedPhoto
            picker.dismiss(animated: true, completion:{self.performImageRecognition((selectedPhoto))})
        }
    }
    
    
    func performImageRecognition(_ image: UIImage) -> String{
        //
        //        let imagePreProcessed = self.processImage(inputImage: image)
        //        imageView2.image = imagePreProcessed
        //
        let tesseract = G8Tesseract(language: "eng", engineMode: .tesseractOnly)
        tesseract?.delegate = self
        
        //            change the engine mode
        //            tesseract.engineMode = .tesseractCubeCombined
        tesseract?.pageSegmentationMode = G8PageSegmentationMode(rawValue: 1)!
        tesseract?.image = image.g8_blackAndWhite()
        tesseract?.recognize()
        
        var text = tesseract?.recognizedText
        text = text?.components(separatedBy: NSCharacterSet.newlines).filter(){$0 != ""}.joined(separator: "\n")
        
        return text!
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
