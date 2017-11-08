//
//  Product.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/31/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation
import SwiftSoup

class Product{
    var name: String
    var price: Double
    var imageUrl: String
    var productUrl: String
    var description: String
    var shortDescription: String
    var rating: String
    var isAdded = false
    
    init(name: String, price: Double, imageUrl: String, productUrl: String, description: String, shortDescription: String, rating: String) {
        self.name = name
        self.price = price
        self.imageUrl = imageUrl
        self.description = description
        self.shortDescription = shortDescription
        self.rating = rating
        var url = URLComponents(string: productUrl)
        url?.scheme = "https"
        self.productUrl = (url?.url?.absoluteString)!
    }
    
    var getPrice: String{
        return "$\(Int(round(price)))"
    }
    
    var convertHtml: String{
        do{
            if description.isEmpty && shortDescription.isEmpty{
                return "No Description Available"
            }
        
            return try Entities.unescape(shortDescription)
        } catch{
            print("Error")
            return ""
        }
    
    }
}
