//
//  FacebookManage.swift
//  LoginKara
//
//  Created by NamHai on 11/5/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import ObjectMapper



class FacebookManage: NSObject , UIApplicationDelegate{
    
    private var completionCallBack:((_ errorMess:NSError?,_ token:String)->Void)? = nil
    
    var dict : [String : AnyObject]!
    let loginManager = FBSDKLoginManager()
    static let shared:FacebookManage  = FacebookManage()
    
    //MARK: - Add to AppDelege
    class func applicationLaunch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    class func applicationActive() {
        FBSDKAppEvents.activateApp()
    }
    
    //ios 9 and early
    class func applicationOpenOldUrl(_ application: UIApplication,_ url: URL,_ sourceApplication: String?,_ annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation:annotation)
        
    }
    
    class func applicationOpenUrl(_ app: UIApplication,_ url: URL,_ options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //        return FBSDKApplicationDelegate.sharedInstance().application(app,
        //                                                                     open: url,
        //                                                                     options: options)
        return FBSDKApplicationDelegate.sharedInstance()
            .application(app,
                         open: url,
                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                         annotation:options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }
    
    //MARK: - Login Manager
    
    func logOut() {
        loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    
    
    func getToken(from view: UIViewController,complete:((_ errorMess:NSError?, _ token:String)->Void)?){
        
        completionCallBack = complete
        
        // still have token, let check
        if ((FBSDKAccessToken.current()) != nil) {
            
            print(FBSDKAccessToken.current().tokenString)
            completionCallBack?(nil, FBSDKAccessToken.current().tokenString.lowercased())
            
        } else{
            
            getAuth(from: view)
            
        }
        
    }
    
    
    func getAuth(from rootView:UIViewController) {
        
        //        let rootView = UIApplication.shared.windows.first!.rootViewController
        
        loginManager.logIn(withReadPermissions: ["email"], from: rootView) {
            [weak self]  (result, error) -> Void in
            
            guard let strongSelf = self else {return}
            
            if (error != nil){
                
                strongSelf.logOut()
                strongSelf.completionCallBack?(error as NSError?, "")
                
            } else if (result?.isCancelled)!{
                
                print("Cancel")
                let userInfo = [
                    NSLocalizedDescriptionKey:  "102",
                    NSLocalizedFailureReasonErrorKey: "User Cancel",
                    ]
                let err = NSError(domain: "com.sm.kara", code: 102, userInfo:userInfo)
                strongSelf.completionCallBack?(err, "")
                
            } else{
                
                print("Logged in")
                strongSelf.completionCallBack?(nil, result?.token.tokenString ?? "")
                
            }
        }
    }
    
    //function is fetching the user data
    
    func getFBUserData(complete:@escaping((_ error:Error?,_ userInfo:[String:Any]?)->(Void))){
        
        let permission = "id, name, picture.type(large), email, first_name, last_name, timezone, gender, location, interested_in, birthday"
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": permission]).start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    print("Error: \(String(describing: error))")
                    complete(error, nil)
                }
                else if  let userInfo = result as? [String: AnyObject] {
                    
                    print("userInfo: \(String(describing: userInfo))")
                    complete(error, userInfo)
                    
                }
                
            })
        }
    }
    
}



