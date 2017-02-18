//
//  SignInVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 13/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper




class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToHome", sender: nil)
        }
    }

    
    //FACEBOOK sign in:-
    @IBAction func facebookBtnPressed(_ sender: UITapGestureRecognizer) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("NIGE: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("NIGE: User cancelled Facebook authentication")
            } else {
                print("NIGE: Successfully autheinticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    //Authentication for MULTIPLE sign in methods with FIREBASE. Need to call this after each set of sign in methods (see above for Facebook):-

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("NIGE: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Successfully auth with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                    
                }
            }
        })
    }

   //EMAIL Sign In - NEED TO ADD IN ***FURTHER ERROR HANDLING***
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("NIGE: Email user authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                        }
                    
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("NIGE: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIGE: Succesfully authenticated withFirebase")
                            
                            if let user = user {
                                
                            self.completeSignIn(id: user.uid)
                        }
                        }
                    })
                }
            })
        }
        
        
        
        
    }
    
    
    func completeSignIn(id: String) {
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        performSegue(withIdentifier: "goToHome", sender: nil)
        
    }
    
    
    
    
    
    
}
