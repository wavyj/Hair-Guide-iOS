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
    @IBOutlet weak var productImage: UIImage!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
