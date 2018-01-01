//
//  FacebookAccountKitManage.swift
//  LoginKara
//
//  Created by NamHai on 11/9/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import Foundation
import AccountKit

class FacebookAccountKitManage: NSObject {
    
    static let shared:FacebookAccountKitManage = FacebookAccountKitManage()
    var accountKit : AKFAccountKit!
    
    // initialize Account Kit
    func setup(){
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit =  AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
    }
    
    func logout(){
        accountKit.logOut()
    }
    
    //MARK: - UI Theme
    func custumizeThemeLoginViewController()-> AKFTheme{
        
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        
        return theme
    }
    
    func getClientTokenString() -> NSString{
        if let tokenString = accountKit.currentAccessToken?.tokenString {
            return tokenString as NSString
        } else {
            return ""
        }
    }
    
    func getFbObjectInfos(){
        self.accountKit.requestAccount{
            (account, error) -> Void in
            
            //Save User Infos
            print(self.getClientTokenString())
            print (account?.accountID as Any)
            print(account!.phoneNumber?.stringRepresentation() as Any)
            
        }
    }
}

