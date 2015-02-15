//
//  MACAddressDetailViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

class MACAddressDetailViewViewModel: MACAddressDetailViewModel {

    // MARK: Propertys
    internal let textFieldTextLength: Observable<Int>

    let viewTitle: Observable<String>
    let macAddressItem: Observable<MACAddressItem?>
    let pickerViewData: Observable<[String]>
    let textFieldText: Observable<String>
    let textFieldPlaceholderText: Observable<String>
    let textViewText: Observable<String>
    let buttonTitle: Observable<String>
    let enabled: Observable<Bool>

    // MARK: Lifecycle
    init(macAddress: MACAddressItem?) {
        self.viewTitle = Observable("New Device")
        self.macAddressItem = Observable(nil)
        self.pickerViewData = Observable(   ["0", "1", "2",
                                          "3", "4", "5",
                                          "6", "7", "8",
                                          "9", "A", "B",
                                          "C", "D", "E", "F"])
        self.textFieldText = Observable("")
        self.textFieldPlaceholderText = Observable("tap to start")
        self.buttonTitle = Observable("LOOK UP")
        self.textViewText = Observable("RESULTS")
        self.textFieldTextLength = Observable(0)

        self.enabled = Observable(true)
    }

    // MARK: UIPicker View
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
            textFieldText.value += pickerViewData.value[row]
        }
    }

    // MARK: UIText Field
    func textFieldTextLength(length: Int) {
        textFieldTextLength.value = length
    }

    func textFieldTextDidChange(newText: String) {
        textFieldText.value = newText
    }

    func resolve(selectedSegmentedIndex: Int, errorHandler: (message: String?) -> ()) {
        if (selectedSegmentedIndex == 0 || selectedSegmentedIndex == 2) {
            var macAddress = textFieldText.value + "00:00:00"
            if validateMACAddress(macAddress) {
                MACAddressStore.sharedStore.createItem(macAddress) {
                    (macAddressItem) in
                    println(macAddressItem)
                }
            } else {
                errorHandler(message: "Invalid MAC address")
            }
        }
    }

    // MARK: Internal Helpers
    func validateMACAddress(macAddress: String) -> Bool {
        return macAddress =~ kValidMACAddressRegex
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