//
//  AccountsCell.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class AccountsCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var socialImg: UIImageView!
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var disconnectBtn: MDCRaisedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
