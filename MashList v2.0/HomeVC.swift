//
//  HomeVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 08/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import GoogleSignIn

var type: String!


class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addView: UIView!
       
    var movieButtonCenter: CGPoint!
    var tvButtonCenter: CGPoint!
   
    var posts = [Post]()
    
    var search: SearchVC!
    
    var users = [User]()
    
    var post: Post!
    
    var mediaItems = [MediaItem]()
    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView.alpha = 0
        
        movieButtonCenter = movieButton.center
        tvButtonCenter = tvButton.center
        
        movieButton.center = addButton.center
        tvButton.center = addButton.center

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelectionDuringEditing = true
        
        observeUserPosts()
        
}
    
    
    
    func observeUserPosts() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let ref = DB_BASE.child("user-posts").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            let postReference = DB_BASE.child("posts").child(postId)
            
            postReference.observe(.value, with: { (snapshot) in
                
                if let postDict = snapshot.value as? Dictionary<String, String> {
                    let key = snapshot.key
                    
                    let post = Post(postKey: key, postData: postDict)
                    self.posts.append(post)
                    
                    
                }

                self.tableView.reloadData()

                
            }, withCancel: nil)
        
        }, withCancel: nil)
        
    }
    
//This FUNC WAS UPDATED WITH THE ONE ABOVE, WHICH USES THE FANNING OUT METHOD TO JUST DISPLAY USER-POSTS:
//    func observePosts() {
//        //Listens out for changes in Firebase posts:-
//        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
//            
//            //This line ensures there are no duplicates:-
//            self.posts = []
//            
//            //This retrieves all the children under the 'child' (i.e. posts):-
//            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                //Take each individual 'child' value using a for..in loop:-
//                for snap in snapshot {
//                    print("SNAP: \(snap)")
//                    if let postDict = snap.value as? Dictionary<String, String> {
//                        let key = snap.key
//                        
//                        let post = Post(postKey: key, postData: postDict)
//                        self.posts.append(post)
//                        
//                    }
//                }
//            }
//            
//            self.tableView.reloadData()
//            
//        })
//
//        }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //refers to Posts array (see above)
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell") as? HomeScreenCell {
            
            //For the images from the cache:-
            if let img = HomeVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
                
            } else {
        
            cell.configureCell(post: post)
            }
            
            return cell
            
            //For safety:-
        } else {
            return HomeScreenCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = posts[indexPath.row]
        print(item)
        
        performSegue(withIdentifier: "toItemVC", sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemVC" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
            let itemsVC = segue.destination as! ItemVC
                
                    itemsVC.post = posts[indexPath.row]
            }
        }
    }
    
    
    
    
    
    
    //DELETE function (used in conjunction with 'allowsSelectionDuringEditing' from viewDidLoad:-
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            
            let post = self.posts[indexPath.row]
            
            
                FIRDatabase.database().reference().child("user-posts").child(uid).child(post.postKey).removeValue(completionBlock: { (error, ref) in
                    if error != nil {
                        print("NIGE: Failed to delete message", error as Any)
                        return
                    }
                    self.posts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                })
                           tableView.reloadData()
            
               }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
         if addView.alpha == 0 {
       
            UIView.animate(withDuration: 0.5, animations: {
                
                self.addView.alpha = 0.8
                self.tvButton.alpha = 1
                self.movieButton.alpha = 1
                self.movieButton.center = self.movieButtonCenter
                self.tvButton.center = self.tvButtonCenter
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
               
                self.addView.alpha = 0
                self.tvButton.alpha = 0
                self.movieButton.alpha = 0
                self.tvButton.center = self.addButton.center
                self.movieButton.center = self.addButton.center
            })
        }
        

       
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
        //Removes Keychain authentication:-
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        //signs out from Firebase:-
        try! FIRAuth.auth()?.signOut()
        
        //Signs out from Google:
        GIDSignIn.sharedInstance().signOut()
    
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
    
    @IBAction func movieButtonPressed(_ sender: UIButton) {
        
      type = "&media=movie"
       
        
        performSegue(withIdentifier: "SearchVC", sender: "HomeVC")
    
    }
    
    
    @IBAction func tvButtonPressed(_ sender: UIButton) {
           type = "&media=tvShow&entity=tvSeason"
      
        
        performSegue(withIdentifier: "SearchVC", sender: "HomeVC")
    }
    
    
    
    
    
    
    
}
