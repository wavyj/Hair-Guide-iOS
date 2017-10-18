//
//  CloudStorageUtil.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/17/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CloudStorageUtil {
    
    var storageRef: StorageReference? = nil
    
    init(){
        storageRef = Storage.storage().reference()
    }
    
    func saveImage(_ image: UIImage, _ post: Post){
        var downloadUrl: String = ""
        var imageData: Data? = nil
        let user = UserDefaultsUtil().loadUserData()
        var format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        
        var imageRefString = "images/\(user.email)" + format.string(from: Date())
        var imageRef: StorageReference? = nil
        // Convert to data
        if let jpeg = image.jpegImg{
            imageData = jpeg
            imageRefString = imageRefString + ".jpg"
            imageRef = storageRef?.child(imageRefString)
        }else if let png = image.pngImg{
            imageData = png
            imageRefString = imageRefString + ".png"
            imageRef = storageRef?.child(imageRefString)
        }
        
        let uploadTask = imageRef?.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            guard let metaData = metaData else{
                // Error
                return
            }
            if let error = error{
                // Error
                print(error.localizedDescription)
            }
            
            post.setImageUrl((metaData.downloadURL()?.absoluteString)!)
        })
        
    }
}

extension UIImage{
    var jpegImg: Data?{
        return UIImageJPEGRepresentation(self, 1)
    }
    
    var pngImg: Data?{
        return UIImagePNGRepresentation(self)
    }
}
