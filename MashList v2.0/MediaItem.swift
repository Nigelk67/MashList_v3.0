//
//  MediaItem.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 30/01/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import Foundation

class MediaItem {


//private var _mediaTitle: String!
private var _director: String!
private var _itemDescription: String!
private var _image: String!
private var _mediaTitle: String!
private var _imgURL: String!
private var _artistName: String!
private var _price: String!
private var _backdropImage: String!
    private var _recommendedBy: String!
    
    
    //Getters & Setters:-
    
    var recommendedBy: String {
        get {
            if _recommendedBy == nil {
                _recommendedBy = ""
            }
            return _recommendedBy
        }
        set {
            _recommendedBy = newValue
        }
    }
       
    var Price: String {
        get {
            if _price == nil {
                _price = ""
            }
            return _price
        }
        set {
            _price = newValue
        }
    }

    
    var imgURL: String {
        get {
            if _imgURL == nil {
                _imgURL = ""
            }
            return _imgURL
        }
        set {
            _imgURL = newValue
        }
    }
    

var image: String {
    if _image == nil {
            _image = ""
    }
    return _image
    }

var mediaTitle: String {
    get {
        if _mediaTitle == nil {
            _mediaTitle = ""
        }
        return _mediaTitle
    }
    
    set {
        _mediaTitle = newValue
    }
}

var director: String {
    get {
        
    if _director == nil {
        _director = ""
    }
    return _director
}
    set {
        _director = newValue
    }
}
    
    
var itemDescription: String {
    get {
        if _itemDescription == nil {
            _itemDescription = ""
        }
        return _itemDescription
    }
    set {
        _itemDescription = newValue
    }
}
    
    
    var ArtistName: String {
        get {
            if _artistName == nil {
                _artistName = ""
            }
            return _artistName
        }
        set {
            _artistName = newValue
        }
    }
    
    
    var backdropImage: String {
        get {
            if _backdropImage == nil {
                _backdropImage = ""
            }
            return _backdropImage
        }
        set {
            _backdropImage = newValue
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
        
        
    
    
}

