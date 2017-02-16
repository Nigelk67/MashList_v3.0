//
//  InitialVC.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 01/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        
    }

   
    
    @IBAction func AddInitialVCButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "SearchVC", sender: "InitialVC")
        
    }
    
    
    
    
    
    
    
    
    
}
