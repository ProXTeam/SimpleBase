//
//  Blog.swift
//  LoginKara
//
//  Created by NamHai on 11/6/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import Foundation

import Foundation

let DEBUG_LEVEL = 5

func BLog(_ logMessage: String, functionName: String = #function, line: Int = #line, fileName:String = #file, column:Int = #column) {
    #if DEBUG
        Swift.print("[\((fileName as NSString).lastPathComponent)] - [Line \(line)] - [\(functionName)]: \(logMessage)")
    #endif
}

func BLogDebug(_ logMessage: String, functionName: String = #function, line: Int = #line, fileName:String = #file, column:Int = #column) {
    if DEBUG_LEVEL == 1 || DEBUG_LEVEL == 5 {
        #if DEBUG
            Swift.print("💜[DEBUG][\((fileName as NSString).lastPathComponent)] - [Line \(line)] - [\(functionName)]: \(logMessage)")
        #endif
    }
}

func BLogInfo(_ logMessage: String, functionName: String = #function, line: Int = #line, fileName:String = #file, column:Int = #column) {
    if DEBUG_LEVEL == 2 || DEBUG_LEVEL == 5 {
        #if DEBUG
            Swift.print("💚[INFO][\((fileName as NSString).lastPathComponent)] - [Line \(line)] - [\(functionName)]: \(logMessage)")
        #endif
    }
}

func BLogWarning(_ logMessage: String, functionName: String = #function, line: Int = #line, fileName:String = #file, column:Int = #column) {
    if DEBUG_LEVEL == 3 || DEBUG_LEVEL == 5 {
        #if DEBUG
            Swift.print("💛[WARNING][\((fileName as NSString).lastPathComponent)] - [Line \(line)] - [\(functionName)]: \(logMessage)")
        #endif
    }
}

func BLogError(_ logMessage: String, functionName: String = #function, line: Int = #line, fileName:String = #file, column:Int = #column) {
    if DEBUG_LEVEL == 4 || DEBUG_LEVEL == 5 {
        #if DEBUG
            Swift.print("❤️[ERROR][\((fileName as NSString).lastPathComponent)] - [Line \(line)] - [\(functionName)]: \(logMessage)")
        #endif
    }
}
