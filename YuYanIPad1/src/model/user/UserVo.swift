//
//  UserVo.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/3/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import Foundation

class UserVo: NSObject, NSCoding{
    var userID : Int32 = -1
    var name : String?
    var pass : String?
    var ip : String?
    var comment : String?
    var jobs : Int32 = 0
    var userSocketID : UInt32 = 0
    
    override var description: String
    {
        get {
            return "userID: \(userID)  name: \(name)  pass: \(pass)  ip: \(ip)  comment: \(comment)  jobs:\(jobs)  userSocketID: \(userSocketID)"
        }
    }

    override init()
    {
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.userID = aDecoder.decodeInt32ForKey("userID")
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.pass = aDecoder.decodeObjectForKey("pass") as? String
        self.ip = aDecoder.decodeObjectForKey("ip") as? String
        self.comment = aDecoder.decodeObjectForKey("comment") as? String
        self.jobs = aDecoder.decodeInt32ForKey("jobs")
        self.userSocketID = UInt32(aDecoder.decodeIntegerForKey("userSocketID"))
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeInt32(userID, forKey: "userID")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(pass, forKey: "pass")
        aCoder.encodeObject(ip, forKey: "ip")
        aCoder.encodeObject(comment, forKey: "comment")
        aCoder.encodeInt32(jobs, forKey: "jobs")
        aCoder.encodeInt32(Int32(userSocketID), forKey: "userSocketID")
    }
}