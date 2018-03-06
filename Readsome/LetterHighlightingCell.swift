//
//  LetterHighlightingCell.swift
//  Readsome
//
//  Created by Nello Carotenuto on 06/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class LetterHighlightingCell: UITableViewCell {

    // Represents the label used to display the selected letter
    @IBOutlet weak var letterLabel: UILabel!
    
    // Represents the label used to make the colored dot next to the letter
    @IBOutlet weak var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
