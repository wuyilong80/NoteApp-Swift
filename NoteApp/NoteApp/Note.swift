//
//  Note.swift
//  NoteApp
//
//  Created by Jayla on 2017/7/25.
//  Copyright © 2017年 wuyilong. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//class Note: NSObject,NSCoding {
class Note:NSManagedObject{
    @NSManaged var titleText: String?
    @NSManaged var text: String?
    @NSManaged var placeText: String?
    @NSManaged var imageName: String?
    
//    required init?(coder aDecoder: NSCoder) {
//        self.text = aDecoder.decodeObject(forKey: "text") as? String
//        self.imageName = aDecoder.decodeObject(forKey: "imageName") as? String
////        super.init()
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.text, forKey: "text")
//        aCoder.encode(self.imageName, forKey: "imageName")
//    }
//    
//    override init() {
//        super.init()
//    }
    
    func image() -> UIImage? {
        if let fileName = self.imageName{
            let homeURL = NSURL(fileURLWithPath: NSHomeDirectory())
            let documentURL = homeURL.appendingPathComponent("Documents")
            let fileURL = documentURL?.appendingPathComponent(fileName)
            if let imageData = NSData(contentsOf: fileURL!){
                return UIImage(data: imageData as Data)
            }
        }
        return nil
    }

    func thumbnailImage() -> UIImage? {
        
        if let image = self.image(){
            
            let thumbnailSize = CGSize(width: 60, height: 60)
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, scale)
            
            let widthRatio = thumbnailSize.width/(image.size.width)
            let heightRatio = thumbnailSize.height/(image.size.height)
            let ratio = max(widthRatio, heightRatio)
            
            let imageSize = CGSize(width: image.size.width*ratio, height: image.size.height*ratio)
            
//            UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
//            [circlePath addClip];
            
            image.draw(in: CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0, y: -(imageSize.height-thumbnailSize.height)/2.0, width: imageSize.width, height: imageSize.height))
            
            let smallImage  = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
            
            return smallImage
        }else{
            return nil
        }
    }
}
