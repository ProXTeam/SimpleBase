//
//  GoogleManage.swift
//  LoginKara
//
//  Created by NamHai on 11/4/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase
import FirebaseAuth


class GoogleManage: NSObject {
    
    var ggUser:GIDGoogleUser? = nil
    
    private var authFinishHandler: ((_ user: GIDGoogleUser?,_ error: Error?) -> Void)?
    
    static let shared:GoogleManage = GoogleManage()
    
    //Put to Appdelegate
    func setup() {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    //if app still support ios 8
    func application(_ application: UIApplication,_  url: URL,_ sourceApplication: String?,_ annotation: Any) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation:annotation)
        
    }
    
    //for ios 9 and up
    func application(_ url: URL,_ options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()
            .handle(url,
                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    //Put into view present
    func setUIDelegate(_ deletate: GIDSignInUIDelegate) {
        GIDSignIn.sharedInstance().uiDelegate = deletate
    }
    
    func signIn(complete:((_ user: GIDGoogleUser?,_ error: Error?) -> Void)?) {
        authFinishHandler = complete
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
}

extension GoogleManage: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        authFinishHandler?(user,error)
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        ggUser = user
        print("User signed into google")
        
        
        /*
         let authentication = user.authentication
         let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
         accessToken: (authentication?.accessToken)!)
         
         Auth.auth().signIn(with: credential) { (user, error) in
         print("User Signed Into Firebase")
         
         
         }
         */
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print("didDisconnectWith error: ", error)
        authFinishHandler?(user,error)
        
    }
}


