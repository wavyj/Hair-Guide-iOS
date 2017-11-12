//
//  ProductGridCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/10/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit

class ProductGridCell: UICollectionViewCell {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Shadow
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        
        // Rounded Corner
        content.layer.masksToBounds = true
        content.layer.cornerRadius = 1.5
    }

}
