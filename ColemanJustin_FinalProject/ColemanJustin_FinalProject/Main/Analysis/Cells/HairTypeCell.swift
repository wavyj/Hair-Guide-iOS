//
//  HairTypeCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/20/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class HairTypeCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var labelText: UILabel!
    
    //MARK: - Variables
    var isCellSelected: Bool = false
    
    func setSelected(){
        if isCellSelected{
            self.backgroundColor = UIColor.white
            isCellSelected = false
        }else{
            self.backgroundColor = MDCPalette.green.tint500
            isCellSelected = true
        }
    }
}
