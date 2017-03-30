//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by Dean Copeland on 3/29/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var memeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
