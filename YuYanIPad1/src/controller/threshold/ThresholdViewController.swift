//
//  ThresholdViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ThresholdViewController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var logTableView: UITableView!
    var LogTableCellIndentifier : String = "LogTableCellIndentifier"
    var logContentArr : NSMutableArray?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set product table view.
        self.logTableView!.dataSource = self
        self.logTableView!.delegate = self
        self.logTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: LogTableCellIndentifier)
        self.logTableView.layoutMargins = UIEdgeInsetsZero
        self.logTableView.separatorInset = UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // Get data.
        getLogData()
    }
    
    func getLogData()
    {
        logContentArr = LogModel.getInstance.getLogContent()
        if logContentArr != nil
        {
            self.logTableView!.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if logContentArr != nil
        {
            return logContentArr!.count
        }else{
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(LogTableCellIndentifier, forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = logContentArr!.objectAtIndex(indexPath.row as Int) as? String
        cell.textLabel?.adjustsFontSizeToFitWidth = false
        cell.textLabel?.font = UIFont.init(name: "Arial", size: 12)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var arry = tableView.visibleCells;
        for(var i = 0; i < arry.count; i++)
        {
            let _cell : UITableViewCell = arry[i] ;
            _cell.contentView.backgroundColor = UIColor.clearColor();
            _cell.textLabel?.textColor = UIColor.whiteColor()
        }
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
        cell.textLabel?.textColor = UIColor.blackColor()        
    }
}
    