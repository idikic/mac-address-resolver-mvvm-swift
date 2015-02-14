//
//  MACAddressDetailViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACAddressDetailViewModel {

    var viewTitle: Dynamic<String> { get }
    var macAddressItem: Dynamic<MACAddressItem?> { get }
    var pickerViewData: Dynamic<[String]> { get }
    var textFieldText: Dynamic<String> { get }
    var textFieldPlaceholderText: Dynamic<String> { get }
    var textFieldTextLength: Dynamic<Int> { get }
    var textViewText: Dynamic<String> { get }
    var buttonTitle: Dynamic<String> { get }
    var enabled: Dynamic<Bool> { get }

    func textFieldTextLength(length: Int)
    func textFieldTextDidChange(newText: String)
    func numberOfComponentsInPickerView() -> Int
    func numberOfRowsInComponentInPickerView() -> Int
    func pickerView(titleForRow row: Int) -> String
    func pickerView(didSelectRow row: Int, inComponent component: Int)

    func download(selectedSegmentedIndex: Int)
    func validateMACAddress(macAddress: String) -> Bool
    func validateIPAddress(ipAddress: String) -> Bool

    func resolveMACAddressFromIPAddress(ipAddress: String) -> String?
    func pingResults(number: NSNumber)

}