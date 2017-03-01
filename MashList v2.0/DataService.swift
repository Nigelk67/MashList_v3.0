//
//  DataService.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 01/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import SwiftKeychainWrapper

//For the images - use Firebase storage:-
let STORAGE_BASE = FIRStorage.storage().reference()

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    
    var mediaTitles = [MediaItem]()
    var TmdbTitles = [MediaItem]()
    var images = [String]()
   
    var mediaItem: MediaItem!
    var search: SearchVC!
    var media: HomeVC!
    
    //DB references to the title-posters:-
    private var _REF_POSTERS = STORAGE_BASE.child("title-posters")

    
    
    //Firebase Database Info:-
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    //Create a variable to identify who the current user is:-
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
            return user
        }
    
    
    
    var REF_POSTERS: FIRStorageReference {
        return _REF_POSTERS
    }
    
    
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    ///dcs:  added completion handler to this method that will send back an array of mediaitem objects
    func downloadiTunesData(trimmedText: String, type: String, completion: @escaping (_ result: [MediaItem]) -> Void) {
            
        Alamofire.request("\(CORE_URL)\(trimmedText)\(COUNTRY)\(type)").responseJSON(completionHandler: { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                //dcs:  results is actually an array of dictionaries, so I casted it as such.  The rest of the method is somewhat self explanatory
                if let results = dict["results"] as? NSArray {
                    
                    
                    for x in 0..<results.count {
                        
                        let mItem: MediaItem = MediaItem()
                        
                        for ( key, value) in (results[x] as? Dictionary<String, AnyObject>)! {
                            if key == "artworkUrl100" {
                                mItem.imgURL = value as! String
                            }
                            
                            if key == "trackName" && type == "&media=movie" {
                                mItem.mediaTitle = value as! String
                            }
                            
                            if key == "artistName" && type == "&media=tvShow&entity=tvSeason" {
                                mItem.mediaTitle = value as! String
                            }
                            
                            if key == "longDescription" {
                                mItem.itemDescription = value as! String
                            }
                            
                            if key == "artistName" && type == "&media=movie" {
                                mItem.director = "Dir: \(value)" 
                            }
                            if key == "collectionName" && type == "&media=tvShow&entity=tvSeason" {
                                mItem.director = value as! String
                            }
                            
                            if key == "collectionPrice" {
                                mItem.Price = String(describing: value)
                            }
                        }
                        
                        self.mediaTitles.append(mItem)
                    }
                }
            }
            
            //dcs: after going through all of the returned data, signal this method complete
            //and include the array of media objects
            
            completion(self.mediaTitles)
    })
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

