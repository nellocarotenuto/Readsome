//
//  LibraryCell.swift
//  Readsome
//
//  Created by Nello Carotenuto on 09/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import UIKit

class LibraryCell : UITableViewCell {

    // Represents the small image in the row
    @IBOutlet weak var scannedImage : UIImageView!
    
    // Represents the title of the row
    @IBOutlet weak var titleLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected : Bool, animated : Bool) {
        super.setSelected(selected, animated: animated)
    }

}
