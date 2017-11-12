//
//  Validate.swift
//  Basic
//
//  Created by Dustin Doan on 11/13/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import UIKit

class Validate: NSObject {
    
    class func isValidEmail(value:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: value)
    }
    
    class func isValidPhoneNumber(value: String) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: value, options: [], range: NSMakeRange(0, value.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == value.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }

}
