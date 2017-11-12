//
//  GuideCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/16/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class GuideCell: UICollectionViewCell{
    
    //MARK: - Outlets
    @IBOutlet weak var frontViewContainer: UIView!
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var guideTitle: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var viewsIcon: UIImageView!
    @IBOutlet weak var editBtn: MDCRaisedButton!
    
    //MARK: - Variables
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        editBtn.setTitle("Edit", for: .normal)
        editBtn.setBackgroundColor(UIColor.white, for: .normal)
        
        // Shadow
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        
        // Rounded Corner
        frontViewContainer.layer.masksToBounds = true
        frontViewContainer.layer.cornerRadius = 1.5
    }

}
