//
//  SearchYoutubeVC.swift
//  SongProcessor
//
//  Created by Dustin Doan on 11/9/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import UIKit

class SearchYoutubeVC: UIViewController {

    @IBOutlet var tableView:UITableView!
    @IBOutlet var lbLog:UILabel!
    
    private var listYoutube = [Items]()
    
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
        
        MovieClient.shared.searchYoutube(searchText: searchText, pageToken: pageToken) { [weak self] result in
            
            guard let sSelf = self else { return }
            sSelf.isLoading = false
            
            switch result {
            case .success(let data):
                
                guard let videos = data?.items else {
                    if let error = data?.error{
                        sSelf.isFull = true
                        
                        sSelf.lbLog.text = error.message
                        sSelf.lbLog.isHidden = false
                    }
                    return
                }
                print(videos.count)
                sSelf.pageToken = data?.nextPageToken ?? ""
                if sSelf.pageToken == "" || videos.count < 20{
                    sSelf.isFull = true
                }
                sSelf.listYoutube.append(contentsOf: videos)
                
            case .failure(let error):
                
                sSelf.isFull = true
                sSelf.lbLog.text = error.localizedDescription
                sSelf.lbLog.isHidden = false
                print("the error \(error)")
            }
            
            sSelf.tableView.reloadData()
            
            
        }
        
        
    }

}


//MARK: - TableView Data Source

extension SearchYoutubeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFull{
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: kLoadingCellId, for: indexPath) as! LoadingTVCell
            cell.indicator.startAnimating()
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongTableViewCell
        cell.updateContentYoutube(listYoutube[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate

extension SearchYoutubeVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1{
            return 50
        }

        return 80
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if !isFull && !isLoading{
                searchRequest()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            return
        }
        
    }
    
}

//MARK: - Cell Delegate

extension SearchYoutubeVC: SongDelegate{
    
    func didSelectSong(at index: Int) {
        //do st
        print(listYoutube[index].snippet?.title ?? "")
    }
    
}
