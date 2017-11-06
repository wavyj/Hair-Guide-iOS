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
    var price: Double
    var imageUrl: String
    var productUrl: String
    var description: String
    var shortDescription: String
    var rating: String
    
    init(name: String, price: Double, imageUrl: String, productUrl: String, description: String, shortDescription: String, rating: String) {
        self.name = name
        self.price = price
        self.imageUrl = imageUrl
        self.productUrl = productUrl
        self.description = description
        self.shortDescription = shortDescription
        self.rating = rating
    }
    
    var getPrice: String{
        return "$" + price.nextUp.description
    }
}
