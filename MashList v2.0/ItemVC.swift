//
//  ItemVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 01/03/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit
import Firebase

class ItemVC: UIViewController {
    
    
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var itemDetail: UITextView!
    @IBOutlet weak var recommendedByLbl: UILabel!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var deletePopUpCentreConstraint: NSLayoutConstraint!

    @IBOutlet weak var deletePopUp: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!

    
    var post: Post!
    var media: MediaItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        directorLbl.text = post.director
        itemDetail.text = post.longDesc
        recommendedByLbl.text = "Recommended by: \(post.recommendedBy)"
        titleLbl.text = post.title
        
        //For the image:-
        let url = URL(string: post.imageURL)
        DispatchQueue.global().async {
            do {
                //gets the data from the download request ( ie:  image )
                let data = try Data(contentsOf: url!)
                
                //puts you back on the main ui thread so you can access the ui elements
                DispatchQueue.global().sync {
                    //sets the thumbnail image
                    self.titleImg.image = UIImage(data: data)
                    
                    
                }
            } catch {
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
       deletePopUp.layer.cornerRadius = 15
    
        
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toHomeVC", sender: "ItemVC")
        
    }
    
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        
       // itemView.isHidden = true
        deletePopUpCentreConstraint.constant = 0
        
        // With Spring Dampers, the higher the number (max = 1) the less bounce you get:-
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("user-posts").child(uid).child(post.postKey).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("NIGE: Failed to delete message", error as Any)
                return
            }
        })
        
         performSegue(withIdentifier: "toHomeVC", sender: "ItemVC")
        
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
       // itemView.isHidden = false
        deletePopUpCentreConstraint.constant = -320
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

        
    }
    
    
    
    
    
    
    
}
