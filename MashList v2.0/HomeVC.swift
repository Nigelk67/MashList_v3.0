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

var type: String!


class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addView: UIView!
    
    var movieButtonCenter: CGPoint!
    var tvButtonCenter: CGPoint!
   
    var posts = [Post]()
    
    var search: SearchVC!
    
    var post: Post!
    
    var mediaItems = [MediaItem]()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    
    //Array for the item - something like - var mediaItems = [MediaItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieButtonCenter = movieButton.center
        tvButtonCenter = tvButton.center
        
        
        movieButton.center = addButton.center
        tvButton.center = addButton.center
        
        
        

        tableView.delegate = self
        tableView.dataSource = self
        //tableView.reloadData()
        
        
        //Listens out for changes in Firebase posts:- NIT SURE THIS IS WORKING:-
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            //This line ensures there are no duplicates:-
            self.posts = []
            
            //This retrieves all the children under the 'child' (i.e. posts):-
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //Take each individual 'child' value using a for..in loop:-
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
        }
            self.tableView.reloadData()
    })
        
}

    
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
    
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if addView.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.addView.alpha = 0.8
                self.tvButton.alpha = 1
                self.movieButton.alpha = 1
                self.movieButton.center = self.movieButtonCenter
                self.tvButton.center = self.tvButtonCenter
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.addView.alpha = 0
                self.tvButton.alpha = 0
                self.movieButton.alpha = 0
                self.tvButton.center = self.addButton.center
                self.movieButton.center = self.addButton.center
            })
        }
        

       // performSegue(withIdentifier: "SearchVC", sender: "HomeVC")
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
        //Removes Keychain authentication:-
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        //signs out from Firebase:-
        try! FIRAuth.auth()?.signOut()
        
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
