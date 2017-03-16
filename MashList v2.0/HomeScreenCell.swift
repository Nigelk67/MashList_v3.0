//
//  HomeScreenCell.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 08/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenCell: UITableViewCell {
    
   
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var titleDesc: UILabel!
    @IBOutlet weak var recommendedByLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
   
    func configureCell(post: Post, img: UIImage? = nil) {
        
        
        titleLbl.text = post.title
        directorLabel.text = post.director
        titleDesc.text = post.longDesc
        recommendedByLbl.text = "Recommended by: \(post.recommendedBy)"
        //dateLbl.text = "Added: \()"

        if img != nil {
            titleImg.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("NIGE: Unable to download image from Firebase Storage")
                    } else {
                        print("NIGE: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.titleImg.image = img
                                //Saves images to the cache:-
                                HomeVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    }
                })
        }
        
        
        
//        let url = URL(string: post.imageURL)
//        DispatchQueue.global().async {
//            do {
//                //gets the data from the download request ( ie:  image )
//                let data = try Data(contentsOf: url!)
//                
//                //puts you back on the main ui thread so you can access the ui elements
//                DispatchQueue.global().sync {
//                    //sets the thumbnail image
//                    self.titleImg.image = UIImage(data: data)
//                    
//                }
//            } catch {
//                
//            }
//        }
//
//        
    }
    

}
