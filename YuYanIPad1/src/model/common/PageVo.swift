//
//  PageVo.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/24/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit

class PageVo : NSObject {
    var currentPage : Int32 = 0
    var totalNumber : Int32 = 0
    var pageSize : Int32 = 15
    var startIndex : Int32 = 0
    
    internal func getJsonStr() -> String
    {
        return "{\"currentPage\":\(currentPage),\"totalNumber\":\(totalNumber),\"pageSize\":\(pageSize),\"startIndex\":\(startIndex)}"
    }
}