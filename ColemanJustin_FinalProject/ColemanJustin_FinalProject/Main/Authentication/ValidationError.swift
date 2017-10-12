//
//  ValidationError.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    public let message: String
    
    public init(message m: String){
        message = m
    }
}
