//
//  PostCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class PostCell: MDCCollectionViewCell{
    
    //MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var likeBtn: MDCFlatButton!
    @IBOutlet weak var commentBtn: MDCFlatButton!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var viewCommentsBtn: MDCFlatButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func applyVisuals(){
        // Shadow
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
        
        // Rounded Corners
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
    
    func downloadImage(_ post: Post){
        spinner.isHidden = false
        spinner.startAnimating()
        
        let url = URL(string: post.mImageUrl)
        let data = try? Data(contentsOf: url!)
        post.mImage = UIImage(data: data!)
        image.image = post.mImage
        spinner.stopAnimating()
    }
    
}
