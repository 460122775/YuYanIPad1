//
//  LogModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 10/16/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class LogModel : NSObject {
    
    let logContentArr : NSMutableArray = NSMutableArray()

    class var getInstance : LogModel
    {
        struct Static {
            static let instance : LogModel = LogModel()
        }
        return Static.instance
    }
    
    func insertLog(logContent : String?)
    {
        print(">>>>>> \(logContent)")
        logContentArr.insertObject(logContent!, atIndex: 0)
    }
    
    func getLogContent() -> NSMutableArray
    {
        return logContentArr
    }
}