//
//  HomeScreenCell.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 08/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit

class HomeScreenCell: UITableViewCell {
    
    
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var titleDesc: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
    func configureCell(mediaItem: MediaItem) {
        
        titleLbl.text = mediaItem.mediaTitle
        directorLabel.text = mediaItem.director
        titleDesc.text = mediaItem.itemDescription
        
        let url = URL(string: mediaItem.imgURL)
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
    

}
