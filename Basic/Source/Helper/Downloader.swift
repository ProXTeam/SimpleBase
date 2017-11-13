//
//  Downloader.swift
//  SongProcessor
//
//  Created by Dustin Doan on 10/26/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import Foundation

protocol DownloadDelegate:NSObjectProtocol {
    
    func downloadProgress(percent:Float)
    func downloadComplete(errorMess:String?, file:String?)
    
}

class Downloader: NSObject, URLSessionDownloadDelegate {

    private var saveUrl = ""
    weak var delegate:DownloadDelegate?
    
    private var progressBlock:((_ progress: Float)->Void)? = nil
    private var completionBlock:((_ errorMess:NSError?)->Void)? = nil

    func download(url: URL, saveTo localUrl: String) {
        
        print("Download:",url)
        print("Will save:", localUrl)
        saveUrl = localUrl
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate:self, delegateQueue: OperationQueue.main)
        
        var request =  URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = "GET"
        
        let task = session.downloadTask(with: request)
        
        task.resume()
    }
    
    func addCompleteHander(complete:((_ errorMess:NSError?)->Void)?){
        
        completionBlock = complete
        
    }
    
    func progressHandler(percentage:((_ progress:Float)->Void)?){
        
        progressBlock = percentage
        
    }
    
    //MARK: - Delegate Complete
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        //        print("download from to:", downloadTask.originalRequest?.url ?? "")
        let dlUrl = downloadTask.originalRequest?.url?.path ?? ""
        let arr = dlUrl.components(separatedBy: "/")
        let fileName = arr.last
        
        // handle HTTP errors here
        if let httpResponse = downloadTask.response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            
            if (statusCode != 200) {
                
                print ("dataTaskWithRequest HTTP status code:", statusCode)
                delegate?.downloadComplete(errorMess: "\(statusCode)", file:fileName)
                
                let errDes = statusCode == 404 ? "File not found" : "Operation was unsuccessful."
                let userInfo = [
                    NSLocalizedDescriptionKey:  errDes,
                    NSLocalizedFailureReasonErrorKey: "The operation timed out."
                ]
                
                let error = NSError(domain: "com.kara", code: statusCode, userInfo:userInfo)
                DispatchQueue.main.async {
                    self.completionBlock?(error)
                }
                
                return;
            }
        }
        
        let doc = Utility.getDocumentsDirectory()
        let path = doc.appendingPathComponent(saveUrl)
        
        if saveUrl.contains("/"){
            
            let parts = saveUrl.components(separatedBy: "/")
            let doc = parts.first
            Utility.createDir(dirName: doc!)
            
        }
        
        
        let fileManager = FileManager()
        
        if fileManager.fileExists(atPath: saveUrl){
            print("file already downloaded")
             self.completionBlock?("File downloaded before")
            return
        }else{
            //save file
            do {
                try fileManager.moveItem(at: location, to: path)
            }catch{
                print("Save file error: \(error.localizedDescription)")
                self.completionBlock?("File save error \(error.localizedDescription)")
                return
            }
        }
        
        
        delegate?.downloadComplete(errorMess: nil, file:fileName)
        
        DispatchQueue.main.async {
            self.completionBlock?(nil)
        }
        
        
    }
    
    //MARK: Download percentage
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
        let percentage = ( Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        delegate?.downloadProgress(percent: percentage)
        DispatchQueue.main.async {
            self.progressBlock?(percentage)
        }
        
    }
    
}
