//
//  MovieClient.swift
//
//
//  Created by Le Hoang Do on 1/22/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import Foundation
import UIKit

let kDefaultItem = 20

class MovieClient: APIClient {
    
    static let shared = MovieClient()
    
    var headerToken = ""
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }

    
    func searchYoutube(searchText: String, pageToken:String, completion: @escaping (Result<YoutubeResult?, APIError>) -> Void) {
        
        let params = [
                   "q":searchText,
                   "pageToken":pageToken,
                   "part":"snippet",
                   "type":"video",
                   "key": kYoutubeKey,
                   "maxResults":kDefaultItem] as [String : Any]

        let itemType = RequestType.youtubeSearch
        let request = itemType.getExtendRequest(params: params)
        
        fetch(with: request, decode: { json -> YoutubeResult? in
            guard let movieFeedResult = json as? YoutubeResult else { return  nil }
            return movieFeedResult
        }, completion: completion)
    }

    
}

