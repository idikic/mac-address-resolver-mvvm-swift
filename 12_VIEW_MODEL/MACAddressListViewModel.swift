//
//  MACAddressListViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 08/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

class MACAddressListViewModel {

  let viewTitle: Observable<String>
  let macAddressStore: MACAddressStore

  required init(macAddressStore: MACAddressStore) {
    self.macAddressStore = macAddressStore
    self.viewTitle = Observable("Devices")
  }

  // MARK: UITableView
  func numberOfSections() -> Int {
    return 1
  }

  func numberOfItemsInSection() -> Int {
    return macAddressStore.allItems.count
  }

  func macAddressAtRow(row: Int, inSection: Int) -> String {
    return macAddressStore.allItems[row].macAddress
  }

  func macAddressCreatedAtRow(row: Int, inSection: Int) -> String {
    return ("\(macAddressStore.allItems[row].dateCreated)")
  }

  func macAddressDeleteAtRow(row: Int, inSection: Int) {
    macAddressStore.removeItemAt(row)
  }

  // MARK: View Model
  func viewModelForMACAddressDetailView() -> MACAddressDetailViewModel {
    return MACAddressDetailViewModel(macAddress: nil)
  }
}