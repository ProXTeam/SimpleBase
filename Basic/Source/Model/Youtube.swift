//
//  Youtube.swift
//  SongProcessor
//
//  Created by Dustin Doan on 11/10/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import Foundation

struct YoutubeResult: Codable {
    let kind : String?
    let etag : String?
    let nextPageToken : String?
    let regionCode : String?
    let pageInfo : PageInfo?
    let items : [Items]?
    let error : YTError?
}

struct YTError : Codable {
    let errors : [YTErrors]?
    let code : Int?
    let message : String?
}

struct YTErrors : Codable {
    let domain : String?
    let reason : String?
    let message : String?
    let extendedHelp : String?
}



struct Default : Codable {
    let url : String?
    let width : Int?
    let height : Int?

}

struct High : Codable {
    let url : String?
    let width : Int?
    let height : Int?
}

struct Id : Codable {
    let kind : String?
    let videoId : String?
}

struct Items : Codable {
    let kind : String?
    let etag : String?
    let id : Id?
    let snippet : Snippet?

}

struct Medium : Codable {
    let url : String?
    let width : Int?
    let height : Int?
}

struct PageInfo : Codable {
    let totalResults : Int?
    let resultsPerPage : Int?

}

struct Snippet : Codable {
    let publishedAt : String?
    let channelId : String?
    let title : String?
    let description : String?
    let thumbnails : Thumbnails?
    let channelTitle : String?
    let liveBroadcastContent : String?

}

struct Thumbnails : Codable {
    let `default` : Default?
    let medium : Medium?
    let high : High?

}
