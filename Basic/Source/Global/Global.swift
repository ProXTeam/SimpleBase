//
//  Global.swift
//  Basic
//
//  Created by Dustin Doan on 11/13/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import UIKit

class Global: NSObject {
    
    var token = ""

    static let shared : Global = {
        let instanceGl = Global()
        return instanceGl
    }()
    
}

