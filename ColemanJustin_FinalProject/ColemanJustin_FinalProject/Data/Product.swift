//
//  Product.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/31/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation

class Product{
    var name: String
    var price: Int
    var imageUrl: String
    var productUrl: String
    
    init(name: String, price: Int, imageUrl: String, productUrl: String) {
        self.name = name
        self.price = price
        self.imageUrl = imageUrl
        self.productUrl = productUrl
    }
}
