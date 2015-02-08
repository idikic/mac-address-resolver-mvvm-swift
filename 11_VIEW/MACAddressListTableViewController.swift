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
        navigationItem.leftBarButtonItem = self.editButtonItem();
        title = viewModel?.title
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
    
    
    // MARK: Edit table view
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            var indexPathToRemove = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
            viewModel?.macAddressDeleteAtRow(indexPathToRemove.row, inSection: indexPathToRemove.section)
            tableView.deleteRowsAtIndexPaths([indexPathToRemove], withRowAnimation: .Fade)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
