//
//  SocketConst.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 10/10/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import Foundation

// Login.
let SOCKETCONST_TYPE_LOGIN : UInt32 = 8
// Chat.
let SOCKETCONST_CHATMESS : UInt32 = 0x88060001
// Start Flag.
var SOCKETCONST_START_FLAG : UInt32 = 0xB2
// IPad ID.
var SOCKETCONST_IPADLOGINFLAG : UInt32 = 0x3EE3

// Minimum Package Size.
var SOCKETCONST_MIN_SIZE : UInt32 = 8

// Net Package Head.
var SOCKETCONST_NET_SOI : UInt32 = 0xa55a4321
// Net Communication version.
var SOCKETCONST_NET_VER : UInt32 = 1
// Net Package Tail.
var SOCKETCONST_NET_EOI : UInt32 = 0x5aa51234

// Net Heart Jump.
var SOCKETCONST_NET_DATA_TYPE_ACTPACK : UInt32 = 0x5551aaa1
// Net Connection Refused.
var SOCKETCONST_NET_DATA_TYPE_MSGPACK : UInt32 = 0x5551aaa2
// Login : UT to PT.
var SOCKETCONST_NET_TYPE_UTTOPT_LOGIN : UInt32 = 0x5551a900

// State of radar.
var SOCKETCONST_NET_TYPE_SC_STATE : UInt32 = 0x8c010000
// Task param of radar, from PT to UT.
//var SOCKETCONST_NET_DATA_TYPE_PTTOUT_PARAM : UInt32 = 0x5551b400
// Login : PT to UT.
var SOCKETCONST_NET_TYPE_CS_LOGIN : UInt32 = 0xc8030000
// Online User List.
var SOCKETCONST_NET_TYPE_SC_USERSTATE : UInt32 = 0x8c050000

// Product List.
var SOCKETCONST_NET_DATA_SC_PRODUCTLISTCMD : UInt32 = 0x880c0000
// Init Product List.
var SOCKETCONST_PRODUCTLISTCMD_INITLIST : UInt32 = 0x880c0001
// Product from PT.
var SOCKETCONST_NET_DATA_TYPE_PTTPUT_GEN_RESULT : UInt32 = 0x5551a600
//// Angle list.
//var SOCKETCONST_NET_DATA_TYPE_ANGLE_LIST : UInt32 = 0x8c090000