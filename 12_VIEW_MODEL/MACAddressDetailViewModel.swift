//
//  MACAddressDetailViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACAddressDetailViewModel {

    var macAddressItem: Dynamic<MACAddressItem?> { get }
    var pickerViewData: Dynamic<[String]> { get }
    var textFieldText: Dynamic<String> { get }
    var textFieldPlaceholderText: Dynamic<String> { get }
    var textViewText: Dynamic<String> { get }
    var buttonTitle: Dynamic<String> { get }

    func numberOfComponentsInPickerView() -> Int
    func numberOrRowsInComponentInPickerView() -> Int
    func titleForRow(row: Int, component: Int) -> String

    func download(selectedSegmentedIndex: Int, macAddress: String)
    func validateMACAddress(macAddress: String) -> Bool
    func validateIPAddress(ipAddress: String) -> Bool

    func resolveMACAddressFromIPAddress(ipAddress: String) -> String?
    func pingResults(number: NSNumber)

}