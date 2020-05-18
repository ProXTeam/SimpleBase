//
//  Endpoint.swift
//  movietrailer
//
//  Created by Le Hoang Do on 1/22/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import Foundation

let kYoutubeKey = "AIzaSyBjZDZkV8SVLZ-2HMWLuVPJoAA2y5MbD-Q"

enum RequestType {
  
    case youtubeSearch
    
    func postRequest(params: [String:Any])->URLRequest?{
        
        let Url = "\(base)\(path)"
        guard let serviceUrl = URL(string: Url) else{
            print("url error")
            return nil
        }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        var retUrl = ""
        params.keys.forEach {
            guard let value = params[$0] else { return }
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let escapedValue = escapedValue {
                retUrl.append("\($0)=\(escapedValue)&")
            }
        }
        retUrl.removeLast()
        request.httpBody = retUrl.data(using: .utf8)
        
        return request
    }
    
    /*
    //For TMDB Base
    
    func getRequest(params: [String:Any]?) -> URLRequest {
        
        var retUrl  = ""
        if let parameters = params, parameters.count > 0 {
            parameters.keys.forEach {
                guard let value = parameters[$0] else { return }
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let escapedValue = escapedValue {
                    retUrl.append("\($0)=\(escapedValue)&")
                }
            }
            retUrl.removeLast()
        }
        let urlStr = "\(TmDbUrl)\(path)?api_key=605da94cf6b54eba8ede4531ec1f2c6c&\(retUrl)"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadRevalidatingCacheData
        return request
        
    }
    */

    //For Google and Itune
    
    func getExtendRequest(params: [String:Any]?) -> URLRequest {
        
        var retUrl  = ""
        if let parameters = params, parameters.count > 0 {
            parameters.keys.forEach {
                guard let value = parameters[$0] else { return }
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let escapedValue = escapedValue {
                    retUrl.append("\($0)=\(escapedValue)&")
                }
            }
            retUrl.removeLast()
        }
        let urlStr = "\(base)\(path)?\(retUrl)"
        let url = URL(string: urlStr)!
        return URLRequest(url: url)
        
    }
    
    
}

extension RequestType {
    
    var base: String {
        switch self {
        case .youtubeSearch:
            return "https://www.googleapis.com/youtube/v3/search"
        }
        
    }
    
    var TmDbUrl: String {
        return "https://api.themoviedb.org/3/"
    }

    
    var path: String {
        switch self {
//        case .googleNear: return "textsearch/json"
        default:
            return ""
        }
    }
    
}
