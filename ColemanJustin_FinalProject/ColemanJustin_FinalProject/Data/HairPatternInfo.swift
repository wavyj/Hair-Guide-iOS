//
//  HairPatternInfo.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/28/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation

class HairPatternInfo{
    
    
    func getInfo(_ type: String)-> [String]{
        let stright = ["Resilient, silky, and robust. ", "Deep Cleaning Shampoo, Lightweight Conditioner, Shine Serum"]
        let wavy = ["Playful and fluid", "Natural Proteins, Lightweight Polymers, Botanical Humectants"]
        let curly = ["Compactly coiled with bounce and high volume", "Breathable Botanicals, Amino Acids, Silk Proteins"]
        let kinky = ["Close-knit curls with a z pattern", "Oils, Butters, Ceramides"]
        switch type {
        case "1A":
            return stright
        case "2A":
            return wavy
        case "2B":
            return wavy
        case "2C":
            return wavy
        case "3A":
            return curly
        case "3B":
            return curly
        case "3C":
            return curly
        case "4A":
            return kinky
        case "4B":
            return kinky
        case "4C":
            return kinky
        default:
            return [""]
        }
    }
}
