//
//  Utility.swift
//  SongProcessor
//
//  Created by Degree on 12/6/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import Foundation
import UIKit


class Utility: NSObject {
    
    //MARK: - Other
    
    class var currentTimestamp: String {
        return "\(Int(Date().timeIntervalSince1970))"
    }
    
    
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
    
    
    class func getAppIcon() -> String{
        
        let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary
        let primaryIconsDictionary = iconsDictionary?["CFBundlePrimaryIcon"] as? NSDictionary
        let iconFiles = primaryIconsDictionary!["CFBundleIconFiles"] as! NSArray
        return iconFiles.lastObject as! String
        
    }
    
    
    class func generateImageWithColor(_ color: UIColor, width:CGFloat, height:CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        //        context?.fill(rect)
        context?.fillEllipse(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
}



extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        if self.size.width < newWidth && self.size.height < newWidth{
            return self
        }
        
        if self.size.width > self.size.height{
            
            let scale = newWidth / self.size.width
            let newHeight = self.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
            self.draw(in: CGRect(x:0,y: 0, width:newWidth,height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
            
        } else{
            
            let scale = newWidth / self.size.height
            let newW = self.size.width * scale
            UIGraphicsBeginImageContext(CGSize(width:newW, height:newWidth))
            self.draw(in: CGRect(x:0,y: 0, width:newW,height: newWidth))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
            
        }
        
        
    }
    
}

extension String {

    
    func md5() -> String! {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
}


