//
//  MACAddressListTableViewController.swift
//  M.A.C.
//
//  Created by iki on 08/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import UIKit

class MACAddressListTableViewController: UITableViewController {

    var viewModel: MACAddressListViewViewModel?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel!.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.numberOfItemsInSection()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("devicesCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = viewModel?.macAddressAtRow(indexPath.row, inSection: indexPath.section)
        cell.detailTextLabel?.text = viewModel?.macAddressCreatedAtRow(indexPath.row, inSection: indexPath.section)
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
}
