//
//  PopUpVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 05/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftKeychainWrapper


class PopUpVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var centerPopupConstraint: NSLayoutConstraint!
    @IBOutlet weak var RecommendPopUpView: UIView!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var itemDetail: UITextView!
    
    //In the PopUp for anon sign ins:-
    @IBOutlet weak var anonPopUpCentreConstraint: NSLayoutConstraint!
    @IBOutlet weak var anonPopUpView: UIView!
    
    var item: MediaItem!
    var itemCell: ItemCell!
    var mediaItems = [MediaItem]()
    
    
    
    // In The Recommended PopUp
    @IBOutlet weak var RecommendedByLbl: UITextField!
    @IBAction func closePopUp(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.RecommendedByLbl.delegate = self
        
        
        nameLbl.text = item.mediaTitle
        directorLbl.text = item.director
        itemDetail.text = item.itemDescription
        
        //For the image:-
        let url = URL(string: item.imgURL)
        DispatchQueue.global().async {
            do {
                //gets the data from the download request ( ie:  image )
                let data = try Data(contentsOf: url!)
                
                //puts you back on the main ui thread so you can access the ui elements
                DispatchQueue.global().sync {
                    //sets the thumbnail image
                    self.thumbImg.image = UIImage(data: data)
                    self.thumbImg.isHidden = false
                    
                }
            } catch {
                
            }
        }
        
        
        anonPopUpView.layer.cornerRadius = 20
        
        popUpView.layer.cornerRadius = 20
        //popUpView.layer.masksToBounds = true
        RecommendPopUpView.layer.cornerRadius = 20
    //    RecommendPopUpView.layer.masksToBounds = true
        
    }
    
    
    
    @IBAction func ShowRecommendedPopup(_ sender: UIButton) {
        
        if (FIRAuth.auth()?.currentUser?.isAnonymous)! {
            
            anonPopUpCentreConstraint.constant = 0
            // With Spring Dampers, the higher the number (max = 1) the less bounce you get:-
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            
        } else {
        
        centerPopupConstraint.constant = 0
        popUpView.isHidden = true
        
        // With Spring Dampers, the higher the number (max = 1) the less bounce you get:-
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
      }
   }
    
    
    
    //2 x Close functions for keyboard - either clicking on return or touching outdside. NOTE need to connect the textField delegate to the VC, and include the self.delegate code in ViewDidLoad.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
          }
    
    
    //Actions on the RECOMMENDED POPUP:-
    
    @IBAction func closeRecommendedPopUp(_ sender: UIButton) {
        
        centerPopupConstraint.constant = -450
        popUpView.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        
        if let img = thumbImg.image {
            
            //Converts image to image data to pass into Firebase (as a JPEG) & compresses it:-
        if let imgData = UIImageJPEGRepresentation(img, 0.1) {
            
            //Gives the image a unique ID:-
            let imgUid = NSUUID().uuidString
            
            //Lets Firebase Storage know what type of image you are passing in:-
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            //Passes unique image into Firebase Storage:-
            DataService.ds.REF_POSTERS.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("NIGE: Unable to upload image to FB Storage")
                } else {
                    print("NIGE: Successfully uploaded image to FB Storage")
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    
                    //Unwrap it for function:-
                    if let url = downloadUrl {
                        
                    self.postToFirebase(imgUrl: url)
                }
            }
        }
    }
        
        performSegue(withIdentifier: "HomeVC", sender: "PopUpVC")
        
    }
  }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        //NEED TO LOGOUT HERE:
        
        //Removes Keychain authentication:-
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        //signs out from Firebase:-
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: "PopUpVC")

    }
    
    
    @IBAction func cancelSignInButtonPressed(_ sender: UIButton) {
        
        anonPopUpCentreConstraint.constant = -450
        
        // With Spring Dampers, the higher the number (max = 1) the less bounce you get:-
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
  
  
    
    //Create an object to post to Firebase:-
    func postToFirebase(imgUrl: String) {
        if (FIRAuth.auth()?.currentUser?.isAnonymous)! {
            print("Need to create a popup to get the user to sign in")
            
        } else {
            
        let userId = FIRAuth.auth()!.currentUser!.uid
//        let timestamp = NSDate().timeIntervalSince1970
        let post: Dictionary<String, AnyObject> = [
        "description": itemDetail.text as AnyObject,
        "director": directorLbl.text as AnyObject,
        "imageURL": imgUrl as AnyObject,
        "recommendedby": RecommendedByLbl.text as AnyObject,
        "title": nameLbl.text as AnyObject,
        "userId": userId as AnyObject,
//        "timestamp": timestamp as AnyObject
        ]
        
        //Posts object to Firebase, creating a unique post ID:
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
       // firebasePost.setValue(post)
            firebasePost.updateChildValues(post) { (error, ref) in
                if error != nil {
                    print(error as Any)
                    return
                }
                
                let userPostsRef = DB_BASE.child("user-posts").child(userId)
                
                let postId = firebasePost.key
                userPostsRef.updateChildValues([postId: 1])
            }
        
            
        }
    }
    
    
    
        
    
    
    
    
    
    
    
    
    
    
   
}
