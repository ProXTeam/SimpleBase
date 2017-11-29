//
//  FacebookManage.swift
//  LoginKara
//
//  Created by NamHai on 11/5/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import Foundation
import FacebookLogin
import FBSDKLoginKit
import ObjectMapper

protocol FacebookManageDelegate: class {
    func fbPushToHomeVctr()
}

class FacebookManage: NSObject , UIApplicationDelegate{
    
    weak var delegate: FacebookManageDelegate?
    
    var dict : [String : AnyObject]!
    let loginManager = LoginManager()
    static let shared:FacebookManage  = FacebookManage()
    

    func applicationWillResignActive() {
        FBSDKAppEvents.activateApp()
    }
    
    func logOut() {
        loginManager.logOut()
    }
    
    func checkCurrentAccessToken(_ rootVctr: UIViewController) {
        if(FBSDKAccessToken.current()) != nil{
            loginManager.logOut()
        }else{
            loginButtonClicked(rootVctr)
        }
    }
    
    //when login button clicked
    @objc func loginButtonClicked(_ rootVctr: UIViewController) {
        loginManager.logIn(readPermissions:[ .publicProfile ], viewController: rootVctr) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    
                    if(self.dict != nil){
                        
                        print(result!)
                        print(self.dict)
                        print(FBSDKAccessToken.current().tokenString)

                        if Mapper<FaceBookObject>().map(JSONObject: self.dict) != nil{
                            let userObj : FaceBookObject =  Mapper<FaceBookObject>().map(JSONObject: self.dict)!
                            
                            //Save FaceBook Oject Infos
                            print(userObj as Any)
                            
                        }else{
                            BLogInfo("Error")
                        }
                        
                        //Push to HomeVtr
                        self.delegate?.fbPushToHomeVctr()
                    }
                }
            })
        }
    }
}
