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
    
    //MARK: - File manager

    class func createDir(dirName: String) {
        
        print("creat folder:",dirName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dataPath = documentsDirectory.appendingPathComponent(dirName)
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: dataPath.path, isDirectory:&isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                print("file exist")
            } else {
                // file exists and is not a directory
                print("folder exist")
            }
        } else {
            // folder does not exist
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
        

    }
    
    class func deleteFile(fileName:String){
        
        let filePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        print("delete", filePath)
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: filePath.path)
        } catch {
            print("Failed to delete file.", error.localizedDescription)
        }
        
    }
    
    
    class func checkFileExist(fileName:String)->(Bool){
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(fileName)?.path
        
//        print(filePath!);
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            print("File availble <--", fileName)
            return true;
        } else {
            print("File not availble <--", fileName)
            return false;
        }
        
    }

    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getFileExtension(file:String)->String{
        
        if let fileExtension = NSURL(fileURLWithPath: file).pathExtension {
            print("fileExtension: ",fileExtension)
            return fileExtension
        }
        
        return ""
        
    }
    
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

//MARK: Quick register nib

extension UITableView{
    
    func registerNib(_ nibClass:AnyClass, _ identifier:String){
        
        let nib = UINib(nibName: String(describing: nibClass.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
        
    }
    
}

extension UICollectionView{
    
    func registerNib(_ nibClass:AnyClass, _ identifier:String){
        
        let nib = UINib(nibName: String(describing: nibClass.self), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
        
    }
    
}

//MARK: Image from color

extension UIColor {
    
    convenience init(_  red: Int,_  green: Int,_ blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    convenience init(_ red: Int,_ green: Int,_ blue: Int,_ alpha: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        let newAlpha = CGFloat(alpha)/1
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
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
    
    var length: Int {
        return self.count
    }

    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    func versionToInt() -> [Int] {
        return self.components(separatedBy: ".")
            .map { Int.init($0) ?? 0 }
    }
    
    
    func md5() -> String! {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
}


