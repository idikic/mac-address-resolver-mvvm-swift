//
//  MACAddressListViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 08/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACAddressListViewModel {

    var title: String { get }
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func macAddressAtRow(row: Int, inSection: Int) -> String
    func macAddressCreatedAtRow(row: Int, inSection: Int) -> String
    func macAddressDeleteAtRow(row: Int, inSection: Int)

    init(macAddressStore: MACAddressStore)
}