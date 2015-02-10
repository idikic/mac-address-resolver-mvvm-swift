//
//  MACAddressDetailViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

class MACAddressDetailViewViewModel: MACAddressDetailViewModel {

    let macAddressItem: Dynamic<MACAddressItem?>
    let pickerViewData: Dynamic<[String]>
    let textFieldText: Dynamic<String>
    let textFieldPlaceholderText: Dynamic<String>
    let textViewText: Dynamic<String>
    let buttonTitle: Dynamic<String>

    init(macAddress: MACAddressItem?) {
        self.macAddressItem = Dynamic(nil)
        self.pickerViewData = Dynamic(   ["0", "1", "2",
                                          "3", "4", "5",
                                          "6", "7", "8",
                                          "9", "A", "B",
                                          "C", "D", "E", "F"])
        self.textFieldText = Dynamic("")
        self.textFieldPlaceholderText = Dynamic("tap to start")
        self.textFieldText = Dynamic("")
        self.buttonTitle = Dynamic("LOOK UP")
        self.textViewText = Dynamic("RESULTS")
    }

    func numberOfComponentsInPickerView() -> Int {
        return 1;
    }

    func numberOrRowsInComponentInPickerView() -> Int {
        return 2;
    }

    func titleForRow(row: Int, component: Int) -> String {
        return "1"
    }

    func download(selectedSegmentedIndex: Int, macAddress: String) {

    }

    func validateMACAddress(macAddress: String) -> Bool {
        return false
    }

    func validateIPAddress(ipAddress: String) -> Bool {
        return false
    }

    func resolveMACAddressFromIPAddress(ipAddress: String) -> String? {
        return "FALSE"
    }

    func pingResults(number: NSNumber) {

    }

}