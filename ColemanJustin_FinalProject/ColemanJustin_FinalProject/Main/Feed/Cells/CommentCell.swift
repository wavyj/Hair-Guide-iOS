//
//  CommentCell Cell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/2/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
