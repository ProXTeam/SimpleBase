//
//  FileManager.swift
//  Basic
//
//  Created by DoLH on 1/2/18.
//  Copyright © 2018 Dustin Doan. All rights reserved.
//

import Foundation
import UIKit

class FileMg: NSObject {
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
   
        
}
