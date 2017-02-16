//
//  Constants.swift
//  MashList v2.0
//
//  Created by Nigel Karan on 30/01/17.
//  Copyright © 2017 MashBin. All rights reserved.
//

import Foundation

var search: SearchVC!

let CORE_URL = "https://itunes.apple.com/search?term="
let COUNTRY = "&country=GB"
let TYPE = "&entity=movie"
let TEST_URL = "https://itunes.apple.com/search?term=Xmen&country=GB&entity=movie"

let SEARCH_URL = "\(CORE_URL)\(search.searchBar.text)\(COUNTRY)\(TYPE)"

let IMAGE_CORE_URL = "https://api.themoviedb.org/3/search/"
let IMAGE_TYPE_URL = "movie?"
let API_KEY = "api_key=8336385d8ec3bcff7fa1204e85e0bc00&query="
let IMAGE_TITLE = "Xmen"
let IMAGE_URL = "\(IMAGE_CORE_URL)\(IMAGE_TYPE_URL)\(API_KEY)\(IMAGE_TITLE)"

typealias DownloadComplete = () -> ()






