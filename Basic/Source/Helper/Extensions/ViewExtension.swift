//
//  ViewExtension.swift
//  Basic
//
//  Created by DoLH on 1/2/18.
//  Copyright © 2018 Dustin Doan. All rights reserved.
//

import UIKit


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


public let kTagIndicator = 123456
public let kYPosition = CGFloat(44)
public let kTagLabel = 9999999

extension UIView {
    
    func showIndicator(){
        showIndicator(style: .gray)
    }
    
    func showIndicator(style: UIActivityIndicatorView.Style) {
        if self.viewWithTag(kTagIndicator) == nil {
            let indicator = UIActivityIndicatorView(style: style)
            indicator.tag = kTagIndicator
            
            self.addSubview(indicator)
            indicator.snp.makeConstraints { (maek) in
                maek.center.equalTo(self.snp.center)
            }
            indicator.startAnimating()
        }
    }
    
    
    func hiddenIndicator() {
        self.subviews.forEach {
            $0.viewWithTag(kTagIndicator)?.removeFromSuperview()
        }
    }
    
    func addLabel(_ title: String) {
        if self.viewWithTag(kTagLabel) == nil {
            let font = UIFont.systemFont(ofSize: 15)
            let height = font.lineHeight
            let width = UIScreen.main.bounds.width - 30
            let label = UILabel(frame: CGRect(x: 15, y: kYPosition, width: width, height: height + 40))
            label.tag = kTagLabel
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.darkGray
            label.text = title
            label.font = font
            label.numberOfLines = 0
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func removeLabel() {
        self.subviews.forEach {
            $0.viewWithTag(kTagLabel)?.removeFromSuperview()
        }
    }
    
    
}
