//
//  PostCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import ImageButter

class PostCell: MDCCollectionViewCell{
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: WebPImageView!
    @IBOutlet weak var likeBtn: MDCFlatButton!
    @IBOutlet weak var commentBtn: MDCFlatButton!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var viewCommentsBtn: MDCFlatButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
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
    
    func butterSetImage(_ post: Post){
        imageView.image = post.mImage
        
    }
    
    func butterDownloadImage(_ post: Post){
        imageView.url = URL(string: post.mImageUrl)
        let loadingView = WebPLoadingView()
        loadingView.lineColor = MDCPalette.blue.tint500
        loadingView.lineWidth = 2
        imageView.loadingView = loadingView
        post.mImage = imageView.image
    }
    
    
    
}
