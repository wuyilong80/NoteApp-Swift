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
    @NSManaged var text: String?
    //    var image: UIImage?
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
    
//    func drawImage() -> UIImage? {
//        
//        var smallImage = self.image()
//        if (image() != nil) {
//            return nil
//        }
////        print("12341234\(smallImage)")
//        let thumbnailSize = CGSize(width: 36, height: 36)
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, scale)
//        
//        let widthRatio = thumbnailSize.width/(smallImage?.size.width)!
//        let heightRatio = thumbnailSize.height/(smallImage?.size.height)!
//        
//        UIGraphicsBeginImageContext(CGSize(width:widthRatio, height:heightRatio))
//        smallImage?.draw(in: CGRect(x:0, y:0, width:widthRatio , height:heightRatio))
//        smallImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return smallImage
//    }

    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

//CGSize thumbnailSize = CGSizeMake(36, 36); //設定縮圖大小
//CGFloat scale = [UIScreen mainScreen].scale; //找出目前螢幕的scale，是網膜技術為2.0
////產生畫布，第一個參數指定大小，第二個參數YES:不透明(黑色底) NO表示背景透明，scale為螢幕scale
//UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, scale);
//
////MAX 結果會等於 UIViewContentModeScaleAspectFill
////MIN 結果會等於 UIViewContentModeScaleAspectFit
//CGFloat widthRatio = thumbnailSize.width / image.size.width;
//CGFloat heightRadio = thumbnailSize.height / image.size.height;
//CGFloat ratio = MAX(widthRatio,heightRadio);
//
//CGSize imageSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
//
////切成圓形
//UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
//[circlePath addClip];

//[image drawInRect:CGRectMake(-(imageSize.width-thumbnailSize.width)/2.0,
//    -(imageSize.height-thumbnailSize.height)/2.0,
//    imageSize.width, imageSize.height)];
//
////取得畫布上的縮圖
//image = UIGraphicsGetImageFromCurrentImageContext();
////關掉畫布
//UIGraphicsEndImageContext();
//return image;
