//
//  FaceBookObject.swift
//  LoginKara
//
//  Created by NamHai on 11/10/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import ObjectMapper

class FaceBookObject:Mappable{
    
    var id: String?
    var name: String?
    //var token: String?
    var picture : picture?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id         <- map["id"]
        name       <- map["name"]
        picture    <- map["picture"]
    }
}

class picture:Mappable{
    
    var data: data?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data         <- map["data"]
    }
}

class data:Mappable{
    
    var url: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        url        <- map["url"]
    }
}
