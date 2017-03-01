//
//  SearchVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 30/01/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit


class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    
    
    var media: HomeVC!
    var post: Post!
    
    var mediaItems = [MediaItem]()
    var mItem: MediaItem = MediaItem()
    
    var searchItem: String!
    var trimmedText: String!
    var itemTitle: String?
    var searchUrl: String!
   
    

    
    //Create array for the search function:-
    var filteredItems = [MediaItem]()
    
    // For the search bar functionality (see further down):-
    var inSearchMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    print(type)
        
        if type == "&media=movie" {
            mediaImage.image = #imageLiteral(resourceName: "MovieButton")
        } else {
            mediaImage.image = #imageLiteral(resourceName: "TVButton")
        }
        
        //dcs: updated this download method to include a completion handler which is called when you download all of the data for the request
//        DataService.ds.downloadiTunesData { (DownloadedItems) in
//            self.mediaItems = DownloadedItems
        
        
            self.collection.dataSource = self
            self.collection.delegate = self
            
            self.searchBar.delegate = self
        
        
           self.collection.reloadData()
 }



    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
        } else {
            //Removes previous search results:-
            DataService.ds.mediaTitles.removeAll()
            //Takes spaces out of the search text:-
            trimmedText = searchBar.text?.replacingOccurrences(of: " ", with: "")
            inSearchMode = true
            //Removes keyboard:-
            searchBar.resignFirstResponder()
            
            DataService.ds.downloadiTunesData(trimmedText: trimmedText, type: type, completion: { (DownloadedItems) in
                self.mediaItems = DownloadedItems
                
            self.collection.reloadData()
                self.collection.backgroundColor = UIColor.black
                self.collection.alpha = 0.7
            })
      }
    }
    
   
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "HomeVC", sender: "SearchVC")
    }
        
    
    
    
    
    //CollectionView protocols:-
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let media = mediaItems[indexPath.row]
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell {
            
            cell.configureCell(item: media)
            
            return cell
            
        } else {
            
            return UICollectionViewCell() // if the above doesn't work, it returns an empty generic cell
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let media = mediaItems[indexPath.row]
        
         performSegue(withIdentifier: "PopUpVC", sender: media)
        // Works in conjunction with the 'prepareforsegue' function below.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    //Prepares for information to be transferred to the new PopUpVC:-
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpVC" {
            if let itemsVC = segue.destination as? PopUpVC {
                if let mediaItem = sender as? MediaItem {
                    itemsVC.item = mediaItem
                    
                }
            }
        }
    }
    
    
    

    
    
    
    
    
}


