//
//  ProductCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/23/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

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
