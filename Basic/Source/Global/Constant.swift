//
//  Constant.swift
//  SongProcessor
//
//  Created by Degree on 4/4/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import UIKit


let kMainColor = UIColor(red: 209/255.0, green: 0/255.0, blue: 106/255.0, alpha: 1)

let kExportFinish = Notification.Name("export_finish")
let kNotiSwitchTab = NSNotification.Name("switchTab")

//back ground
let urlThumb = "http://anhdep99.com/wp-content/uploads/2016/02/hot-girl-nhu-y-de-thuong-trong-vay-hong.jpg"

let testUrl = "https://lrc-nct.nixcdn.com/2015/02/20/4/3/8/9/1424401350189.lrc?_=1510516261408"


enum DownloadStatus {
    case notYet
    case downloaded
    case downloading
}



class Constant: NSObject {

}
