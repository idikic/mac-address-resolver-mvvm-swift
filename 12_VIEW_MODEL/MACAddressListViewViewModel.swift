//
//  MACAddressListViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 08/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

class MACAddressListViewViewModel : MACAddressListViewModel {

    let macAddressStore: MACAddressStore!
    var macAddressItems: [MACAddressItem]

    required init(macAddressStore: MACAddressStore) {
        self.macAddressStore = macAddressStore
        self.macAddressItems = self.macAddressStore.allItems
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItemsInSection() -> Int {
        return macAddressItems.count
    }

    func macAddressAtRow(row: Int, inSection: Int) -> String {
        return macAddressItems[row].macAddress
    }

    func macAddressCreatedAtRow(row: Int, inSection: Int) -> String {
        return ("\(macAddressItems[row].dateCreated)")
    }
}