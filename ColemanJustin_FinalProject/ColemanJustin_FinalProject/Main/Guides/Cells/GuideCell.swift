//
//  GuideCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/16/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit

class GuideCell: UICollectionViewCell{
    
    //MARK: - Outlets
    @IBOutlet weak var frontViewContainer: UIView!
    @IBOutlet weak var backViewContainer: UIView!
    @IBOutlet weak var backYConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontYConstraint: NSLayoutConstraint!
    @IBOutlet weak var backwidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var guideTitle: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var viewsIcon: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likesIcon: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    //MARK: - Variables
    var isOpen = false
    var backWidthOrig: CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = false
        backWidthOrig = backwidthConstraint.constant
        self.frontYConstraint.constant = 0
        self.backYConstraint.constant = 0
        
        createShadow()
        createRoundCorner()
    }
    
    func createShadow(){
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2
    }
    
    func createRoundCorner(){
        self.layer.cornerRadius = 6
        frontViewContainer.layer.cornerRadius = 6
        backViewContainer.layer.cornerRadius = 6
        frontViewContainer.layer.masksToBounds = true
        backViewContainer.layer.masksToBounds = true
    }
    
    func cellIsOpen(_ bool: Bool){
        
        if (bool){
            UIView.animate(withDuration: 0.2, animations: {
                // Open
                self.frontYConstraint.constant = -50
                self.backYConstraint.constant = 50
                //backwidthConstraint.constant = backWidthOrig + 50
                self.layoutIfNeeded()
            }, completion: { (complete) in
                self.isOpen = bool
            })
            
        } else{
            UIView.animate(withDuration: 0.2, animations: {
                // Close
                self.frontYConstraint.constant = 0
                self.backYConstraint.constant = 0
                self.backwidthConstraint.constant =  self.backWidthOrig
                self.layoutIfNeeded()
            }, completion: { (complete) in
                self.isOpen = bool
            })
        }
    }
    
    func close(){
        isOpen = false
        // Close
        frontYConstraint.constant = 0
        backYConstraint.constant = 0
        backwidthConstraint.constant =  backWidthOrig
        self.layoutIfNeeded()
    }

}
