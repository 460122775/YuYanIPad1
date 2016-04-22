//
//  ConfigView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/26/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ConfigView : UIView, UITextFieldDelegate
{
    @IBOutlet var mapFileSizeLabel: UILabel!
    @IBOutlet var clearMapCacheBtn: UIButton!
    @IBOutlet var productSizeLabel: UILabel!
    @IBOutlet var clearProductCacheBtn: UIButton!
    @IBOutlet var productCacheLineImg: UIImageView!
    @IBOutlet var productCacheConfigImg: UIImageView!
    @IBOutlet var saveConfigBtn: UIButton!
    
    @IBOutlet var ipInput1: UITextField!
    @IBOutlet var ipInput2: UITextField!
    @IBOutlet var ipInput3: UITextField!
    @IBOutlet var ipInput4: UITextField!
    
    
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
        self.ipInput1.delegate = self
        self.ipInput2.delegate = self
        self.ipInput3.delegate = self
        self.ipInput4.delegate = self
        let ipArr = IP_Server.componentsSeparatedByString(".")
        if ipArr.count == 4
        {
            self.ipInput1.text = ipArr[0]
            self.ipInput2.text = ipArr[1]
            self.ipInput3.text = ipArr[2]
            self.ipInput4.text = ipArr[3]
            
        }
        super.drawRect(rect)
    }
    
    func setViewByData()
    {
        productSizeLabel.text = "\(Double(CacheManageModel.getInstance.getCacheSizeForProductFile()) / 1000.00)" + "  /  " + "1024000  KB"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if range.length == 1
        {
            return true
        }else if range.location > 2{
            return false
        }
        switch string
        {
            case "0","1","2","3","4","5","6","7","8","9":
                let array = Array(arrayLiteral: textField.text)
                if array.count >= 3 {
                    return false
                }
                return true
            default:
                return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.tag == 1
        {
            self.ipInput2.becomeFirstResponder()
        }else if textField.tag == 2{
            self.ipInput3.becomeFirstResponder()
        }else if textField.tag == 3{
            self.ipInput4.becomeFirstResponder()
        }else if textField.tag == 4{
            if self.ipInput1.text == nil || (self.ipInput1.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! <= 0
                || Int32(self.ipInput1.text!)! > 255
                || Int32(self.ipInput1.text!)! < 0
            {
                self.ipInput1.becomeFirstResponder()
            }else if self.ipInput2.text == nil || (self.ipInput2.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! <= 0
                || Int32(self.ipInput2.text!)! > 255
                || Int32(self.ipInput2.text!)! < 0
            {
                self.ipInput2.becomeFirstResponder()
            }else if self.ipInput3.text == nil || (self.ipInput3.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! <= 0
                || Int32(self.ipInput3.text!)! > 255
                || Int32(self.ipInput3.text!)! < 0
            {
                self.ipInput3.becomeFirstResponder()
            }else if self.ipInput4.text == nil || (self.ipInput4.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! <= 0
                || Int32(self.ipInput4.text!)! > 255
                || Int32(self.ipInput4.text!)! < 0
            {
                self.ipInput4.becomeFirstResponder()
            }else{
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    @IBAction func ipInputSaveBtnClick(sender: UIButton)
    {
        if self.ipInput1.text != nil && (self.ipInput1.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! > 0
            && Int32(self.ipInput1.text!)! < 255
            && Int32(self.ipInput1.text!)! >= 0
            && self.ipInput2.text != nil && (self.ipInput2.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! > 0
            && Int32(self.ipInput2.text!)! < 255
            && Int32(self.ipInput2.text!)! >= 0
            && self.ipInput3.text != nil && (self.ipInput3.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! > 0
            && Int32(self.ipInput3.text!)! < 255
            && Int32(self.ipInput3.text!)! >= 0
            && self.ipInput4.text != nil && (self.ipInput4.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! > 0
            && Int32(self.ipInput4.text!)! < 255
            && Int32(self.ipInput4.text!)! >= 0
        {
            let ipStr = self.ipInput1.text?.stringByAppendingString(".").stringByAppendingString(self.ipInput2.text!).stringByAppendingString(".").stringByAppendingString(self.ipInput3.text!).stringByAppendingString(".").stringByAppendingString(self.ipInput4.text!)
            print(ipStr)
            NSUserDefaults.standardUserDefaults().setObject(ipStr, forKey: IPSTRING)
            IP_Server = ipStr!
            IP_PT = ipStr!
            URL_Server = "http://\(IP_Server):\(PORT_SERVER)/XYSystem"
            URL_DATA = "http://\(IP_Server):\(PORT_SERVER)/data"
            SocketCenter.getInstance.closeSocket()
            SocketCenter.getInstance.conntcpclient()
        }
    }
    
    @IBAction func clearProductFileCache(sender: AnyObject)
    {
        CacheManageModel.getInstance.clearCacheForProductFile()
        setViewByData()
    }
}