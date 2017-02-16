//
//  PopUpVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 05/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit
import Alamofire


class PopUpVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var centerPopupConstraint: NSLayoutConstraint!
    @IBOutlet weak var RecommendPopUpView: UIView!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var itemDetail: UITextView!
    
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
        //DataService.ds.downloadiTunesData(trimmedText: trimmedText, completion: { (DownloadedItems) in
        //self.mediaItems = DownloadedItems
        
        self.RecommendedByLbl.delegate = self

        
        
             nameLbl.text = item.mediaTitle
        directorLbl.text = "Director: \(item.director)"
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
        
        popUpView.layer.cornerRadius = 20
        //popUpView.layer.masksToBounds = true
        RecommendPopUpView.layer.cornerRadius = 20
    //    RecommendPopUpView.layer.masksToBounds = true
        
    }
    
    
    @IBAction func ShowRecommendedPopup(_ sender: UIButton) {
        centerPopupConstraint.constant = 0
        popUpView.isHidden = true
        
       
        // With Spring Dampers, the higher the number (max = 1) the less bounce you get:-
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
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
        
        centerPopupConstraint.constant = -320
        popUpView.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeVC", sender: "PopUpVC")
        
    }
    
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeVC", sender: "PopUpVC")
    }
    
    
    
    
    
    
    
    
    
    
    
   
}
