//
//  IKIMasterTableViewController.swift
//  M.A.C.
//
//  Created by iki on 16/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class IKIMasterTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    // MARK - Insert new object
    func insertNewObject(barButtonItem: UIBarButtonItem) {
    
        // Create a new MACAddress device
        var newItem = MACAddressStore.sharedStore.createItem("00:00:00:00:00:00")
        
        // Figure out where that device is in the arrat
        var itemIndex: NSInteger?
        for (index, element) in enumerate(MACAddressStore.sharedStore.allItems) {
        
            if element === newItem {
            
                itemIndex = index
            }
        }
        
        // Construct the index path
        var indexPath = NSIndexPath(forItem: itemIndex!, inSection: 0)
        
        // Insert the new device at the bottom of the list
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        
    }
    
    
    
    // #pragma mark - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MACAddressStore.sharedStore.allItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("devicesCell", forIndexPath: indexPath) as UITableViewCell
        
        // Load saved MACAddressItem's into cell's
        var macAddressItem = MACAddressStore.sharedStore.allItems[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = macAddressItem.company
        //cell.detailTextLabel?.text = Utility.sharedStore.dateToString(macAddressItem.dateCreated)
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            var macAddressItems = MACAddressStore.sharedStore.allItems
            
            // Figure out where that device is in the arrat
            for (index, element) in enumerate(MACAddressStore.sharedStore.allItems) {
                
                if index == indexPath.row {
                    
                    //Remove item from MACAddressStore
                    MACAddressStore.sharedStore.removeItem(element)
                }
            }
            
            var indexPathToRemove = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
            tableView.deleteRowsAtIndexPaths([indexPathToRemove], withRowAnimation: .Fade)
            
           
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
        
        
        
        
        
    }
    */



}
