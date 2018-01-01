//
//  NSNumberExtension.swift
//  SmartMediaBaseSwift
//
//  Created by NamHai on 10/14/17.
//  Copyright © 2017 SmartMedia JSC. All rights reserved.
//


import UIKit

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
