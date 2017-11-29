//
//  StringExtension.swift
//  LoginKara
//
//  Created by NamHai on 11/6/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import Foundation

extension String {

    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
