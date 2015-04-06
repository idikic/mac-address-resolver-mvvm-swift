//
//  MACAddressListTableViewController.swift
//  M.A.C.
//
//  Created by iki on 08/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import UIKit

let AddNewMACAddressItemSegueIdentifier = "AddMACAddressItem"

class MACAddressListTableViewController: UITableViewController {

  var viewModel: MACAddressListViewModel?

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = self.editButtonItem();
    tableView.tableFooterView = UIView()
    if let unwrappedViewModel = viewModel {
      bindToViewModel()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    self.tableView.reloadData()
  }

  // MARK: Binding
  private func bindToViewModel() {
    viewModel!.viewTitle.bindAndFire {
      [unowned self] in
      self.title = $0
    }
  }

  // MARK: Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    var destinationViewController =
      segue.destinationViewController.topViewController as MACAddressDetailViewController

    if segue.identifier == AddNewMACAddressItemSegueIdentifier {
      let viewModel = self.viewModel?.viewModelForMACAddressDetailView()
      destinationViewController.viewModel = viewModel
    }
  }

  @IBAction func unwindToMACAddressList(unwindSegue: UIStoryboardSegue) {}
}

// MARK: UITable View Data Source
extension MACAddressListTableViewController: UITableViewDataSource {

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

}

// MARK: UITable View Delegate
extension MACAddressListTableViewController: UITableViewDelegate {

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
