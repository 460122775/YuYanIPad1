//
//  File.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class SwitchToolView: UIView
{
    @IBOutlet var switchControlBtn: UIButton!
    @IBOutlet var upBtn: UIButton!
    @IBOutlet var upDownImg: UIImageView!
    @IBOutlet var downBtn: UIButton!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var leftRightImg: UIImageView!
    @IBOutlet var rightBtn: UIButton!
    @IBOutlet var buttonContainerV: UIView!
    @IBOutlet var buttonContainerH: UIView!
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect)
    {
        self.buttonContainerV.layer.masksToBounds = true
        self.buttonContainerH.layer.masksToBounds = true
    }
    
    @IBAction func swtichControlBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
        if sender.selected == true
        {
            self.buttonContainerV.frame = CGRectMake(140, 140, 48, 0)
            self.buttonContainerH.frame = CGRectMake(140, 140, 0, 48)
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.buttonContainerV.frame = CGRectMake(140, 0, 48, 140)
                self.buttonContainerH.frame = CGRectMake(0, 140, 140, 48)
            })
        }else{
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.buttonContainerV.frame = CGRectMake(140, 140, 48, 0)
                self.buttonContainerH.frame = CGRectMake(140, 140, 0, 48)
            })
        }
    }
    
    @IBAction func upBtnClick(sender: UIButton)
    {
        
    }
    
    @IBAction func downBtnClick(sender: UIButton)
    {
    
    }
    
    @IBAction func leftBtnClick(sender: UIButton)
    {
        
    }
    
    @IBAction func rightBtnClick(sender: UIButton)
    {
        
    }
    
    
}