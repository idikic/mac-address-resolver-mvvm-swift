//
//  MACAddressDetailViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

class MACAddressDetailViewViewModel: MACAddressDetailViewModel {

    internal let textFieldTextLength: Dynamic<Int>

    let viewTitle: Dynamic<String>
    let macAddressItem: Dynamic<MACAddressItem?>
    let pickerViewData: Dynamic<[String]>
    let textFieldText: Dynamic<String>
    let textFieldPlaceholderText: Dynamic<String>
    let textViewText: Dynamic<String>
    let buttonTitle: Dynamic<String>

    init(macAddress: MACAddressItem?) {
        self.viewTitle = Dynamic("New Device")
        self.macAddressItem = Dynamic(nil)
        self.pickerViewData = Dynamic(   ["0", "1", "2",
                                          "3", "4", "5",
                                          "6", "7", "8",
                                          "9", "A", "B",
                                          "C", "D", "E", "F"])
        self.textFieldText = Dynamic("")
        self.textFieldPlaceholderText = Dynamic("tap to start")
        self.buttonTitle = Dynamic("LOOK UP")
        self.textViewText = Dynamic("RESULTS")
        self.textFieldTextLength = Dynamic(0)
    }

    func textFieldLength(length: Int) {
        textFieldTextLength.value = length
    }
    
    func numberOfComponentsInPickerView() -> Int {
        return 6;
    }

    func numberOfRowsInComponentInPickerView() -> Int {
        return pickerViewData.value.count;
    }

    func pickerView(titleForRow row: Int) -> String {
        return pickerViewData.value[row]
    }

    func pickerView(didSelectRow row: Int, inComponent component: Int) {

        if textFieldTextLength.value > component {
            let startIndex = advance(textFieldText.value.startIndex, component)
            let endIndex = advance(startIndex, 1)

            var rangeOfStringToReplace = Range(start: startIndex, end: endIndex)
            var newString = pickerViewData.value[row]
            var replacedString =
                textFieldText.value.stringByReplacingCharactersInRange(rangeOfStringToReplace, withString: newString)
            textFieldText.value = replacedString

        } else {
            textFieldText.value = textFieldText.value + pickerViewData.value[row]
        }
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