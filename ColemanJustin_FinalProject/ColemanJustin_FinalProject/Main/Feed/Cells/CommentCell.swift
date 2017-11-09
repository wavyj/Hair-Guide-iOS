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
    @IBOutlet weak var content: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Shadow
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        
        //Corner Radius
        content.layer.masksToBounds = true
        content.layer.cornerRadius = 1.5
    }

}
