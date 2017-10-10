//
//  FrontViewCell.swift
//  
//
//  Created by Justin Coleman on 10/10/17.
//

import UIKit
import expanding_collection

class FrontViewCell: BasePageCollectionCell {
    //MARK: - Outlets
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var frontViewTitle: UILabel!
    @IBOutlet weak var backViewLikes: UILabel!
    @IBOutlet weak var backViewAuthor: UILabel!
    @IBOutlet weak var backViewDescription: UILabel!
    @IBOutlet weak var backViewHeartIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        frontViewTitle.layer.shadowRadius = 2
        frontViewTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        frontViewTitle.layer.shadowOpacity = 0.2
    }

}
