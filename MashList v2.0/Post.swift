//
//  Post.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 26/02/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import Foundation

class Post {
    
    private var _longDesc: String!
    private var _director: String!
    private var _imageURL: String!
    private var _recommendedBy: String!
    private var _title: String!
    private var _postKey: String!
    private var _userId: String!
    private var _type: String!
    
    //Getters and Setters:-
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
        set {
            _type = newValue
        }
    }
    
    var userId: String {
        get {
            if _userId == nil {
                _userId = ""
            }
            return _userId
        }
        set {
            _userId = newValue
        }
    }
    
    var postKey: String {
        get {
            if _postKey == nil {
                _postKey = ""
            }
            return _postKey
        }
        set {
            _postKey = newValue
        }
    }
    
    var title: String {
        get {
            if _title == nil {
                _title = ""
            }
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    
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
    
    
    var imageURL: String {
        get {
            if _imageURL == nil {
                _imageURL = ""
            }
            return _imageURL
        }
        set {
            _imageURL = newValue
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
    
    var longDesc: String {
        get {
            if _longDesc == nil {
            _longDesc = ""
        }
        return _longDesc
    }
    set {
    _longDesc = newValue
    
    }
}
    
    init(postKey: String, postData: Dictionary<String, String>) {
        self._postKey = postKey
        if let longDesc = postData["description"] {
            self._longDesc = longDesc
        }
        if let imageURL = postData["imageURL"] {
            self._imageURL = imageURL
        }
        if let director = postData["director"] {
            self._director = director
        }
        if let recommendedBy = postData["recommendedby"] {
            self._recommendedBy = recommendedBy
        }
        if let title = postData["title"] {
            self._title = title
        }
        
    }
    

    
    
    
    
    
    
    
    
    
    
}
