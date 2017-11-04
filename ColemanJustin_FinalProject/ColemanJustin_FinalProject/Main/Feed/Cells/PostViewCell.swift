//
//  PostViewCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/2/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class PostViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeBtn: UIImageView!
    @IBOutlet weak var commentBtn: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareBtn: UIImageView!
    
    //MARK: - Variables

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeBtn.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        commentBtn.image = UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate)
        shareBtn.image = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        
        for i in [likeBtn, commentBtn, shareBtn]{
            i?.tintColor = MDCPalette.blue.tint500
        }
    
    }

}
