//
//  LoadingCVC.swift
//  movietrailer
//
//  Created by Le Hoang Do on 1/22/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import UIKit
import SnapKit

let kLoadingCell = "loadingCell"

class LoadingCVCell: UICollectionViewCell {
    
    var indicator:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}

let kLoadingCellId = "loadingTVCell"

class LoadingTVCell: UITableViewCell {
    
    var indicator:UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        indicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}
