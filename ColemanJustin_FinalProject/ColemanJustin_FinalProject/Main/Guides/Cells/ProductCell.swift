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
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        createShadow()
    }
    
    func createShadow(){
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2
    }

}
