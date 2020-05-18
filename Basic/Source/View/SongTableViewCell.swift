//
//  SongTableViewCell.swift
//  SongProcessor
//
//  Created by Degree on 4/4/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import UIKit
import Kingfisher

protocol SongDelegate:NSObjectProtocol {
    func didSelectSong(at index:Int)
}

let idSongCell = "songCell"

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet var imgThumb:UIImageView!
    @IBOutlet var lbTitle:UILabel!
    @IBOutlet var lbSinger:UILabel!

    @IBOutlet var btPlay:UIButton!
    
    weak var delegate:SongDelegate?
    
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btPlay.layer.cornerRadius = btPlay.frame.size.height/2
        imgThumb.layer.cornerRadius = 7
        
    }

    func updateContentYoutube(_ obj:Items){
        
        if  let singerAvatar = obj.snippet?.thumbnails?.default?.url {
            imgThumb.kf.setImage(with: URL(string:singerAvatar))
        }
        
        lbTitle.text = obj.snippet?.title
        lbSinger.text = obj.snippet?.channelTitle

        
    }
    
    @IBAction func didPressSingButton(_ sender:UIButton){
        
        delegate?.didSelectSong(at: index)
        
    }
    
}
