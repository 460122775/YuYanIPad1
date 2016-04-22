//
//  SocketCenter.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/9/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import UIKit
import Darwin.C
import CocoaAsyncSocket

// Net Package Head.
struct tagPtNetPackHead
{
    var SOI : UInt32 //0xa55a4321
    var DataPackSize : UInt32
    var VER : UInt32
    var DataType : UInt32
    var PackID : UInt32
}

// Command Package Head.
struct tagNetLogin
{
    var startFlag : Int32
    var id : Int32
    var type : Int32
    var subType : Int32
    var status : Int32
}

class SocketCenter: NSObject, NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate{
    
    var service : NSNetService?
    var gcdSocket : GCDAsyncSocket!
    var appIsActive : Bool = true
    
    class var getInstance : SocketCenter
    {
        struct Static {
            static let instance : SocketCenter = SocketCenter()
        }
        return Static.instance
    }
    
    /*
    *  Delegates of GCDAsyncSokcket
    **/
    func socket(socket : GCDAsyncSocket, didConnectToHost host:String, port p:UInt16)
    {
        connectCount = 1
        LogModel.getInstance.insertLog("Socket Connect Success !!!")
        NSNotificationCenter.defaultCenter().postNotificationName("\(SOCKET)\(SUCCESS)", object: nil)
    }
    
    var connectCount : UInt32 = 0
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
    {
        heartJumpTimer?.invalidate()
        LogModel.getInstance.insertLog("Socket Connect Close !!![\(err)]")
        NSNotificationCenter.defaultCenter().postNotificationName("\(SOCKET)\(FAIL)", object: nil)
        if appIsActive == true
        {
            connectCount += 1
            if connectCount >= 3
            {
                return
            }
            SocketCenter.getInstance.conntcpclient()
        }
    }
    
    private var bufferByteArray : NSMutableData = NSMutableData()
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int)
    {
//        LogModel.getInstance.insertLog(">>>>>>>>>>>>>>>>>  Receive Data From PT [length:\(data.length)]")
        // Composite data.
        bufferByteArray.appendData(data)
        var offset : Int = 0
        var head : UInt32 = 0
        var sizeFlag : UInt32 = 0
        // Longer than package min size.
        while UInt32(bufferByteArray.length) > SOCKETCONST_MIN_SIZE
        {
            head = 0
            bufferByteArray.getBytes(&head, range: NSRange.init(location: offset + 0, length: 4))
            sizeFlag = 0
            bufferByteArray.getBytes(&sizeFlag, range: NSRange.init(location: offset + 4, length: 4))
            // Wrong package with some reasons.
            if sizeFlag <= 0 || head != SOCKETCONST_NET_SOI
            {
                bufferByteArray.length = 0
                break
            }else{
                // Enough for a package.
                if bufferByteArray.length >= offset + Int(sizeFlag)
                {
                    var _dataType : UInt32 = 0
                    bufferByteArray.getBytes(&_dataType, range: NSMakeRange(offset + 12, 4))
                    let dataSrc : NSData = bufferByteArray.subdataWithRange(NSRange.init(location: offset + 20, length: Int(sizeFlag) - 20 - 4))
                    // Send Notification...
                    dispatchPackage(packageData: dataSrc, dataType: _dataType)
//                    LogModel.getInstance.insertLog("SocketCenter resolved reading data : [ \(offset + Int(sizeFlag))/\(bufferByteArray.length)]")
                    // Finish reading the package.
                    if bufferByteArray.length == offset + Int(sizeFlag)
                    {
                        bufferByteArray.length = 0
                        break
                    }
                // Save incomplete package.
                }else{
                    bufferByteArray = NSMutableData(data:bufferByteArray.subdataWithRange(NSMakeRange(offset, bufferByteArray.length - offset)))
                    break
                }
            }
            offset += Int(sizeFlag)
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int)
    {
//        LogModel.getInstance.insertLog("Write data with tag of \(tag)")
    }
    
    /*
    *  END OF Delegates
    **/

    
    internal func conntcpclient()
    {
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(IPSTRING)
        if NSUserDefaults.standardUserDefaults().objectForKey(IPSTRING) != nil
        {
            IP_Server = NSUserDefaults.standardUserDefaults().objectForKey(IPSTRING) as! String
            IP_PT = NSUserDefaults.standardUserDefaults().objectForKey(IPSTRING) as! String
        }else{
            NSUserDefaults.standardUserDefaults().setObject(IP_Server, forKey: IPSTRING)
        }
        appIsActive = true
        if gcdSocket == nil
        {
            gcdSocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
            if gcdSocket == nil
            {
                return
            }else{
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SocketCenter.closeSocket), name: "\(APP_STOP)", object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SocketCenter.conntcpclient), name: "\(APP_ACTIVE)", object: nil)
            }
        }
        do{
            if gcdSocket.isDisconnected == true
            {
                try self.gcdSocket.connectToHost(IP_PT, onPort: PORT_PT, withTimeout: 10)
            }
        }catch let error as NSError{
            LogModel.getInstance.insertLog("SocketCenter Connect Socket FAIL [err:\(error)]")
        }
    }
    
    internal func closeSocket()
    {
        appIsActive = false
        if gcdSocket != nil && gcdSocket.isConnected
        {
            gcdSocket.disconnect()
        }
    }
    
    var heartJumpTimer : NSTimer?
    internal func dispatchPackage(packageData _packageData : NSData, dataType _dataType : UInt32)
    {
        // Send Notification...
        switch _dataType
        {
            case SOCKETCONST_NET_DATA_TYPE_ACTPACK:
//                LogModel.getInstance.insertLog("Receive Heart Jump Data from PT.")
                break
            
            case SOCKETCONST_NET_TYPE_SC_STATE:
                var tagSysStatus : Int32 = 0
                _packageData.getBytes(&tagSysStatus, range: NSMakeRange(0, 4))
                RadarStatus = String(tagSysStatus)
                NSNotificationCenter.defaultCenter().postNotificationName("\(RECEIVE)\(RADARSTATUS)", object: String(tagSysStatus))
//                LogModel.getInstance.insertLog("Receive radar state from PT.\(tagSysStatus)")
                break
            
            case SOCKETCONST_NET_TYPE_CS_LOGIN:
                var _loginStatus : Int32 = 0
                _packageData.getBytes(&_loginStatus, range: NSMakeRange(20 + 96, 4))
                if _loginStatus == USERCONST_LOGIN_IN_SUCCESS
                {
                    if heartJumpTimer == nil
                    {
                        heartJumpTimer = NSTimer.scheduledTimerWithTimeInterval(HeartPkgCycle, target: self, selector: #selector(SocketCenter.sendHeartJumpData), userInfo: nil, repeats: true)
                    }
                    heartJumpTimer!.fire()
                }
                UserModel.getInstance.loginResultControl(packageData: _packageData, status: _loginStatus)
                break
            
            case SOCKETCONST_NET_TYPE_SC_USERSTATE:
                LogModel.getInstance.insertLog("Receive Online User List.")
                break
            
//            case SOCKETCONST_NET_DATA_SC_PRODUCTLISTCMD:
//                
//                break
            
            case SOCKETCONST_NET_DATA_SC_PRODUCTLISTCMD:
                LogModel.getInstance.insertLog("Receive product list.")
                NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCTTYPELIST)\(SELECT)", object: _packageData)
                break
            
            case SOCKETCONST_NET_DATA_TYPE_PTTPUT_GEN_RESULT:
                ProductUtilModel.getInstance.receiveProductFromSocketControl((String.init(data: _packageData.subdataWithRange(NSMakeRange(20, _packageData.length - 20 - 4)), encoding: NSUTF8StringEncoding))!)
                break
            
            default:
                LogModel.getInstance.insertLog("Resolving dataSrc :[Type_\(_dataType):\(_packageData.length)]")
                break
        }
    }
    
    internal func send(type _type : UInt32, subType _subType : UInt32, status _status : UInt32, data _data : NSData)->Bool
    {
        if gcdSocket.isConnected == false
        {
            conntcpclient()
        }
        var type = _type
        var subType = _subType
        var status = _status
        // Send Data.
        let socketData : NSMutableData = NSMutableData()
        var socketDataLength : UInt32 = 20 + 20 + UInt32(_data.length) + 4 + 4
        LogModel.getInstance.insertLog("SocketCenter Get Sending_Data [length:\(_data.length)]")
        socketData.appendBytes(&SOCKETCONST_NET_SOI, length: 4)
        socketData.appendBytes(&socketDataLength, length: 4)
        socketData.appendBytes(&SOCKETCONST_NET_VER, length: 4)
        switch type
        {
            case SOCKETCONST_TYPE_LOGIN: socketData.appendBytes(&SOCKETCONST_NET_TYPE_UTTOPT_LOGIN, length: 4)
            default: return false
        }
        socketData.appendBytes(&ZeroValue, length: 4)
        socketData.appendBytes(&SOCKETCONST_START_FLAG, length: 4)
        socketData.appendBytes(&SOCKETCONST_IPADLOGINFLAG, length: 4)
        socketData.appendBytes(&type, length: 4)
        socketData.appendBytes(&subType, length: 4)
        socketData.appendBytes(&status, length: 4)
        socketData.appendData(_data)
        socketData.appendBytes(&ZeroValue, length: 4)
        socketData.appendBytes(&SOCKETCONST_NET_EOI, length: 4)
        LogModel.getInstance.insertLog("SocketCenter Start Sending Data [length:\(socketData.length)]")
        gcdSocket.writeData(socketData, withTimeout: -1.0, tag: Int(type))
        gcdSocket.readDataWithTimeout(-1.0, tag: Int(type))
        return true
    }

    internal func sendHeartJumpData()
    {
        // Send Data...
        let socketData : NSMutableData = NSMutableData()
        var socketDataLength : UInt32 = 20 + 1024 + 4
//        LogModel.getInstance.insertLog("SocketCenter Send Heart Jump Data.")
        socketData.appendBytes(&SOCKETCONST_NET_SOI, length: 4)
        socketData.appendBytes(&socketDataLength, length: 4)
        socketData.appendBytes(&SOCKETCONST_NET_VER, length: 4)
        socketData.appendBytes(&SOCKETCONST_NET_DATA_TYPE_ACTPACK, length: 4)
        socketData.appendBytes(&ZeroValue, length: 4)
        socketData.appendData(NSMutableData(length: 1024)!)
        socketData.appendBytes(&SOCKETCONST_NET_EOI, length: 4)
        gcdSocket.writeData(socketData, withTimeout: -1.0, tag: 1)
        gcdSocket.readDataWithTimeout(-1.0, tag: 1)
    }
}
