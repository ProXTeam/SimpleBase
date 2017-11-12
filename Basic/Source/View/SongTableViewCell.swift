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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func updateContentYoutube(yt:Youtube){
        
        if  let singerAvatar = yt.thumbHigh ?? yt.thumbMedium ?? yt.thumbDefault {

            imgThumb.kf.setImage(with: URL(string:singerAvatar),
                                 placeholder:UIImage(named:"placeholder"))
        }
        
        lbTitle.text = yt.title
        lbSinger.text = yt.channelTitle

        
    }
    
    @IBAction func didPressSingButton(_ sender:UIButton){
        
        delegate?.didSelectSong(at: index)
        
    }
    
}
