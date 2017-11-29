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

protocol GoogleManageDelegate : class{
    func googlePushToHomeVctr()
}

class GoogleManage: NSObject {
    
    weak var delegate : GoogleManageDelegate?
    
    var databaseRef: DatabaseReference!
    var authFinishHandler: ((_ success: Bool) -> Void)?
    
    static let shared:GoogleManage = GoogleManage()
    
    func setup() {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func setUIDelegate(_ deletate: GIDSignInUIDelegate) {
        GIDSignIn.sharedInstance().uiDelegate = deletate
    }
    
    func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func application(_ url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}

extension GoogleManage: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("User signed into google")
        
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                       accessToken: (authentication?.accessToken)!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            print("User Signed Into Firebase")
            self.databaseRef = Database.database().reference()
            self.databaseRef.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snapshot = snapshot.value as? NSDictionary
                
                if(snapshot == nil) {
                self.databaseRef.child("user_profiles").child(user!.uid).child("name").setValue(user?.displayName)
                self.databaseRef.child("user_profiles").child(user!.uid).child("email").setValue(user?.email)
    
                }
                
                //Save User Infos
                
                
                //Push To Survey Vctr (Delegate/Block)
                self.delegate?.googlePushToHomeVctr()
                
                guard let auth = self.authFinishHandler else {return }
                
                auth(user != nil)
            })
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
