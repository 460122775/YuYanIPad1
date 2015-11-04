//
//  ChatViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController : UIViewController
{
    var friendListView : FriendListView?
    var chatMainView : ChatMainView?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Init friend list view.
        self.friendListView = (NSBundle.mainBundle().loadNibNamed("FriendListView", owner: self, options: nil) as NSArray).lastObject as? FriendListView
        self.friendListView!.frame.origin = CGPointMake(0, 0)
        self.view.addSubview(self.friendListView!)
        // Init chat view.
        self.chatMainView = (NSBundle.mainBundle().loadNibNamed("ChatMainView", owner: self, options: nil) as NSArray).lastObject as? ChatMainView
        self.chatMainView!.frame.origin = CGPointMake(240, 0)
        self.view.addSubview(self.chatMainView!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    