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
import GoogleSignIn




class SignInVC: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self

        passwordField.delegate = self
        
        
        
        
    }
    
    //Checks to seeif user already has an account:-
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToHome", sender: nil)
        }
    }
    
    
    //Gets rid of keyboard after the 'DONE' key is pressed in the password field:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
//                FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
//                    if error != nil {
//                        let alert = UIAlertController(title: "WTF??", message: error?.localizedDescription, preferredStyle: .alert)
//                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                        alert.addAction(defaultAction)
//                        self.present(alert, animated: true, completion: nil)
//                    } else {
//                    print("NIGE: Successfully linked Facebook sign in with anon user")
//                        //Add in the Firebase Database stuff HERE!!
//                    }
//
//                })
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
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    
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
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                        }
                
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("NIGE: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIGE: Succesfully authenticated withFirebase")
                            //LINKS anonymous user to email and password account:-
//                            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: pwd)
//                            FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
//                                if error != nil {
//                                    let alert = UIAlertController(title: "Unable to link your ananymous account", message: error?.localizedDescription, preferredStyle: .alert)
//                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                                    alert.addAction(defaultAction)
//                                    self.present(alert, animated: true, completion: nil)
//                                } else {
//                                    print("Linked to anon user")
//                                    //Need to add in the link to create a Database user
//                                }

                            if let user = user {
                                let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                    }
                
            }
        })
       }
    })
  }
}

    
    
    //ANONYMOUS SIGN IN:-
    @IBAction func anonymousSignin(_ sender: Any) {
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if error != nil {
                print("NIGE: Unable to sign in anonymously")
                let alert = UIAlertController(title: "WTF??", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("NIGE: Successfully sign in anonymously")
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
        
    }
    
    
    //GOOGLE SIGN IN:-
    @IBAction func googleSignInButtonPressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        
//        //Links to anonymous account:-
//        guard let authentication = user.authentication else {return}
//        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//        FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
//            if error != nil {
//                print("NIGE: Unable to link anon user using Google")
//            } else {
//                print("Successfully linked anon user with Google account")
//            }
//        })

        performSegue(withIdentifier: "goToHome", sender: nil)
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        //To write into the Firebase Db:-
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        //For autosign in:-
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        performSegue(withIdentifier: "goToHome", sender: nil)
        
    }
    
    
    
    
    
}
