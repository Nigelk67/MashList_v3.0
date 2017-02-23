//
//  ItemCell.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 30/01/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var itemDescriptionLbl: UITextView!
    
    
    var mediaItem: MediaItem!
    var ds: DataService!
    

    func configureCell(item: MediaItem) {
        
        //dcs: just loaded more data points to fill out the CV a bit
        self.nameLbl.text = item.mediaTitle
        self.directorLbl.text = item.director
        self.itemDescriptionLbl.text = item.itemDescription
        
        
        //dcs:  commented this out as its no longer needed
        //self.thumbImg.image = UIImage(named: "\(self.mediaItem.image)")
        
        //dcs:  load up the 100x100 version of the image
        let url = URL(string: item.imgURL)
        
        //async operation to download the image for each cell
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

        
    }
    
}
