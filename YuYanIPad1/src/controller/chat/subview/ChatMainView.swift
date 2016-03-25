//
//  ChatMainView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ChatMainView : UIView, UITextViewDelegate
{
    @IBOutlet var voiceSwitchBtn: UIButton!
    @IBOutlet var speakBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var inputAreaView: UITextView!
    @IBOutlet var cancelImg: UIImageView!
    @IBOutlet var contentTableView: UITableView!
    @IBOutlet var bottomView: UIView!
    
    override init(frame : CGRect)
    {
        super.init(frame:frame)
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatMainView.keyBoardShowControl(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatMainView.keyBoardHideControl(_:)), name: UIKeyboardWillHideNotification, object: nil)
        self.inputAreaView.delegate = self
    }
    
    @IBAction func voiceBtnClick(sender: UIButton)
    {
        if speakBtn.hidden == true
        {
            self.speakBtn.hidden = false
            self.inputAreaView.hidden = true
            sender.setImage(UIImage(named: "chat_btn_keyboard_normal.png"), forState: UIControlState.Normal)
            sender.setImage(UIImage(named: "chat_btn_keyboard_pressed.png"), forState: UIControlState.Highlighted)
        }else{
            self.speakBtn.hidden = true
            self.inputAreaView.hidden = false
            sender.setImage(UIImage(named: "chat_btn_voice_normal.png"), forState: UIControlState.Normal)
            sender.setImage(UIImage(named: "chat_btn_voice_pressed.png"), forState: UIControlState.Highlighted)
        }
        
    }
    
    @IBAction func speakBtnTouchUpIn(sender: UIButton)
    {
        self.cancelImg.hidden = true
        sender.selected = false
    }
    
    @IBAction func speakBtnTouchDown(sender: UIButton)
    {
        self.cancelImg.hidden = false
        sender.selected = true
    }
    
    @IBAction func speakBtnTouchUpOut(sender: UIButton)
    {
        self.cancelImg.hidden = true
        sender.selected = false
    }
    
    @IBAction func addBtnCLick(sender: UIButton)
    {
        
    }
    
    @IBAction func sendBtnClick(sender: UIButton)
    {
        
    }
    
    // UITextView delegate.
    func textViewDidBeginEditing(textView: UITextView)
    {
        
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        
    }
    
    var keyboardHeight : CGFloat = 0.0
    func keyBoardShowControl(notification : NSNotification)
    {
        if self.keyboardHeight == 0.0
        {
            let keyboardInfo : (AnyObject!) = NSDictionary(dictionary: notification.userInfo!).objectForKey(UIKeyboardFrameEndUserInfoKey)
            let keyboardRect:CGRect = keyboardInfo.CGRectValue as CGRect
            self.keyboardHeight = keyboardRect.size.height
        }
        self.contentTableView.frame.size = CGSizeMake(self.contentTableView.frame.size.width, self.contentTableView.frame.size.height - keyboardHeight)
        self.bottomView.frame.origin = CGPoint(x: 0, y: self.contentTableView.frame.origin.y
            + self.contentTableView.frame.size.height)
    }
    
    func keyBoardHideControl(notification : NSNotification)
    {
        self.contentTableView.frame.size = CGSizeMake(self.contentTableView.frame.size.width, self.contentTableView.frame.size.height + keyboardHeight)
        self.bottomView.frame.origin = CGPoint(x: 0, y: self.contentTableView.frame.origin.y
            + self.contentTableView.frame.size.height)
    }
}