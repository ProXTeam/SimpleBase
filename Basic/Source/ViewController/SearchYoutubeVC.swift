//
//  SearchYoutubeVC.swift
//  SongProcessor
//
//  Created by Dustin Doan on 11/9/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class SearchYoutubeVC: UIViewController {

    @IBOutlet var tableView:UITableView!
    @IBOutlet var lbLog:UILabel!
    
    private var listYoutube = [Youtube]()
    
    private var isLoading = false
    private var isFull = false
    

    private var searchText = "Ed Sheeran"
    private var pageToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LoadingTVCell.self, forCellReuseIdentifier: kLoadingCellId)
        tableView.registerNib(SongTableViewCell.self, idSongCell)
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 80
        
        lbLog.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("search song did appear")
        searchRequest()
        
    }
    
    
    func searchRequest() {
        

        if isLoading{
            return
        }
        
        lbLog.isHidden = true
        isLoading = true
        
        
        let param:Parameters = [
            "q":searchText,
            "pageToken":pageToken,
            "part":"snippet",
            "type":"video",
            "key":"AIzaSyCrIWZB791uaByRS58RUvH_0wfI81PJ_ys",
            "maxResults":20,
            "videoCategoryId":10]
        print(param)
        let url = "https://www.googleapis.com/youtube/v3/search"
        print(url)
        
        
        Alamofire.request(url, method: .get , parameters:param)
            .responseObject { (response:DataResponse<ResponseYoutube>) in
                
                DispatchQueue.main.async {
                    
                    self.isLoading = false
                    if self.pageToken.isEmpty {
                        self.listYoutube.removeAll()
                        self.tableView.reloadData()
                    }
                    
                    guard  response.error == nil,
                        let value = response.result.value,
                        value.code != 0 else {
                            
                            let mes = response.error?.localizedDescription ?? response.result.value?.message ?? "unknow"
                            self.lbLog.text = mes
                            self.lbLog.isHidden = false
                            
                            self.isFull = true
                            self.tableView.reloadData()
                            return
                            
                    }
                    
                    if let records = value.items{
                        
                        if records.count < 20 {
                            self.isFull = true
                        }
                        
                        self.pageToken = value.nextToken ?? ""
                        self.listYoutube.append(contentsOf: records)
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
        }
        
    }

}


extension SearchYoutubeVC: SongDelegate{
    
    func didSelectSong(at index: Int) {
        
        //do st
    }
    
    
}

//MARK: - TableView Data Source

extension SearchYoutubeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFull || self.listYoutube.count == 0{
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  section == 1{
            return 1
        }
        
        return listYoutube.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingTVCell
            cell.indicator.startAnimating()
            
//            let vc = UIStoryboard(name: "Pager", bundle: nil).instantiateViewController(withIdentifier: "pageVC") as! SimpleViewController
//            self.addChildViewController(vc)
//            cell.addSubview(vc.view)
            
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongTableViewCell
        cell.updateContentYoutube(yt: listYoutube[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate

extension SearchYoutubeVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if indexPath.section == 1{
//            return 500
//        }
        
        return 80
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if !isFull && !isLoading{
                
//                searchRequest()
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            //open list recorded
        }
        
    }
    
}
