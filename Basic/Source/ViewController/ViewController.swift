//
//  ViewController.swift
//  Basic
//
//  Created by Dustin Doan on 11/13/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: UIViewController {

    @IBOutlet var lbProgress:UILabel!
    private var downloadStatus = DownloadStatus.notYet
    private let dl = Downloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func downloadAction(){
        
        if downloadStatus == .downloading {
            return
        }
        
        if downloadStatus == .downloaded {
            HUD.flash(.label("file downloaded"))
            return
        }
    
        downloadStatus = .downloading
        
        let url = URL(string:testUrl)!
        let savePath = "fileName.dat"

        dl.download(url: url, saveTo: savePath)
        dl.progressHandler { [weak self] (progress) in
            self?.lbProgress.text = "\(progress*100)%"
        }
        dl.addCompleteHander { [weak self] (error) in
            if (error != nil){
                self?.downloadStatus = .downloaded
                HUD.flash(.labeledSuccess(title: "Finish", subtitle: nil))
            } else {
                self?.downloadStatus = .notYet
                HUD.flash(.labeledError(title: "Error", subtitle: error?.localizedDescription))
            }
        }
    
    }
    
    @IBAction func btnShowPress(){
        
        let vc = UIStoryboard(name: "Pager", bundle: nil).instantiateViewController(withIdentifier: "pageVC") as! SimpleViewController
        self.navigationController?.pushViewController(vc, animated: true)
//        TestRequest.testRequest()
        
    }

}

