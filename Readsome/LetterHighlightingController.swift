//
//  LetterHighlightingController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 06/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class LetterHighlightingController : UITableViewController {

    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView : UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView : UITableView, numberOfRowsInSection section : Int) -> Int {
        // Get the dictionary and count the entries inside it
        let letters = preferences.dictionary(forKey : "letters") as! [String : NSData]
        
        return letters.count
    }

    
    override func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        // Get the cell as a custom one
        let cell = tableView.dequeueReusableCell(withIdentifier : "letterHighlightedCell", for : indexPath) as! LetterHighlightingCell

        // Get the dictionary of letters and extract the saved letter-color pairs
        let letters = preferences.dictionary(forKey : "letters") as! [String : NSData]
        let letter = Array(letters.keys)[indexPath.row]
        let letterColor = NSKeyedUnarchiver.unarchiveObject(with : letters[letter]! as Data) as? UIColor

        // Set the text and the color into the cell
        cell.letterLabel.text = letter
        cell.colorLabel.backgroundColor = letterColor
        
        return cell
    }

    
    override func tableView(_ tableView : UITableView, commit editingStyle : UITableViewCellEditingStyle, forRowAt indexPath : IndexPath) {
        if editingStyle == .delete {
            var letters = preferences.dictionary(forKey : "letters") as! [String : NSData]
            
            let letter = Array(letters.keys)[indexPath.row]
            letters.removeValue(forKey: letter)
            preferences.set(letters, forKey: "letters")
            
            tableView.deleteRows(at : [indexPath], with : .fade)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue : UIStoryboardSegue, sender : Any?) {
        let index = tableView.indexPathForSelectedRow?.row
        let letters = preferences.dictionary(forKey: "letters") as! [String : Data]
        
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
                case "editHighlightedLetter" :
                    let letter = Array(letters.keys)[index!]
                    let destination = segue.destination as! TextHighlightingController
                    destination.textToHighlight = letter
                    destination.selectedColor = NSKeyedUnarchiver.unarchiveObject(with : letters[letter]!) as? UIColor
                default:
                    break
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated : Bool) {
        tableView.reloadData()
    }

}
