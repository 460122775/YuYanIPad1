//
//  ProductVo.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/24/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit

class ProductVo : NSObject {
    var id : Int32 = 0
    var name : String = ""
    var pos_file : String = ""
    var file_size : Float32 = 0
    var pos_picture : String = ""
    var type : Int32 = 0
    var time : Int32 = 0
    var layer : Int32 = 0
    var scan_mode : Int32 = 0
    var process : Int32 = 0
    var note : String = ""
    var mcode : String = ""
    
    internal func getJsonStr() -> String
    {
        return "{\"id\":\(id),\"name\":\"\(name)\",\"pos_file\":\"\(pos_file)\",\"file_size\":\(file_size),\"pos_picture\":\"\(pos_picture)\",\"type\":\(type),\"time\":\(time),\"layer\":\(layer),\"scan_mode\":\(scan_mode),\"process\":\(process),\"note\":\"\(note)\",\"mcode\":\"\(mcode)\"}"
    }
}