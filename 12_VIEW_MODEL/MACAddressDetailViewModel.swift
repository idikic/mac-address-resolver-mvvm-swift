//
//  MACAddressDetailViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation
import Reachability

enum Result<T> {
  case Success(Box<T>)
  case Error(String)
}

final public class Box<T> {
  public let unbox: T
  public init(_ value: T) {
    self.unbox = value
  }
}

class MACAddressDetailViewModel {

  // MARK: Propertys
  internal let textFieldTextLength: Observable<Int>

  let viewTitle: Observable<String>
  let macAddressItem: Observable<MACAddressItem?>
  let segmentedControlSelectedSegment: Observable<Int>
  let pickerViewData: Observable<[String]>
  let textFieldText: Observable<String>
  let textFieldPlaceholderText: Observable<String>
  let textViewText: Observable<String>
  let buttonTitle: Observable<String>

  // MARK: Lifecycle
  init(macAddress: MACAddressItem?) {
    self.viewTitle = Observable("New Device")
    self.macAddressItem = Observable(nil)
    self.pickerViewData = Observable(["0", "1", "2",
                                      "3", "4", "5",
                                      "6", "7", "8",
                                      "9", "A", "B",
                                      "C", "D", "E", "F"])
    self.textFieldText = Observable("")
    self.textFieldPlaceholderText = Observable(Constants.UIString.textFieldTapToStart)
    self.buttonTitle = Observable(Constants.UIString.buttonTitleLookUp)
    self.textViewText = Observable("RESULTS")
    self.textFieldTextLength = Observable(0)
    self.segmentedControlSelectedSegment = Observable(0)
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
          textFieldText.value.stringByReplacingCharactersInRange(rangeOfStringToReplace,
                                                                 withString: newString)
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

  func resolve(errorHandler: (message: String?) -> ()) {
    if (segmentedControlSelectedSegment.value == 0 || segmentedControlSelectedSegment.value == 2) {
      var macAddress: String
      if count(textFieldText.value) == 6 {
        macAddress = textFieldText.value + Constants.UIString.macAddressEmptySuffix
      } else {
        macAddress = textFieldText.value
      }
      if validateMACAddress(macAddress) {
        MACAddressStore.sharedStore.createItem(macAddress) {
            (result) in
          if let macAddressItem = result {
            println(macAddressItem)
            self.textViewText.value = self.prepareMACAddressItemForDisplay(macAddressItem)
          }
        }
      } else {
        errorHandler(message: Constants.UIString.messageInvalidMACAddress)
      }
    } else {
      var ipAddress = textFieldText.value
      if isReachableForLocalWiFi() {
        if validateIPAddress(ipAddress) {
          SimplePingHelper.ping(ipAddress) {
             [unowned self] (success) in
              if success {
                switch self.resolveMACAddressFromIPAddress(ipAddress) {
                    case .Success(let macAddress):
                      self.viewTitle.value = macAddress.unbox
                      self.textFieldText.value = self.formatMACAddressForPickerView(macAddress.unbox)
                      self.buttonTitle.value = Constants.UIString.buttonTitleLookUp
                      self.segmentedControlSelectedSegment.value = 0
                    case .Error(let error): errorHandler(message: error)
                }
              } else {
                errorHandler(message: Constants.UIString.messageDestinationHostUnreachable)
              }
          }
        } else {
          errorHandler(message: Constants.UIString.messageInvalidIPAddress)
        }
      } else {
        errorHandler(message: Constants.UIString.messageNoLocalWiFiConnection)
      }
    }
  }

  // MARK: UISegmented Control
  func segmentedControlDidSelectSegment(selectedSegment: Int) {
    segmentedControlSelectedSegment.value = selectedSegment

    switch selectedSegment {
    case 0:
      buttonTitle.value = Constants.UIString.buttonTitleLookUp
    case 1:
      buttonTitle.value = Constants.UIString.buttonTitleResolveIPAddress
    case 2:
      buttonTitle.value = Constants.UIString.buttonTitleLookUp
    default:
      return
    }
  }

  // MARK: Internal Helpers
  internal func validateMACAddress(macAddress: String) -> Bool {
    return macAddress =~ kValidMACAddressRegex
  }

  internal func formatMACAddressForPickerView(macAddress: String) -> String {
    var formattedMACAddress: String = ""
    for character in macAddress {
      if character != ":" {
        formattedMACAddress.append(character)
      }
    }
    var index = advance(formattedMACAddress.startIndex, 6)

    return formattedMACAddress.substringToIndex(index)
  }

  internal func prepareMACAddressItemForDisplay(resultMACAddressItem: MACAddressItem) -> String {
    var displayString: String = ""

    if let company = resultMACAddressItem.company {
      displayString = company + "\n"
    }

    if let address = resultMACAddressItem.address1 {
      displayString += "\n" + address + "\n"
    }

    if let country = resultMACAddressItem.country {
      displayString += "\n" + country + "\n"
    }

    displayString += "\n" + "\(resultMACAddressItem.dateCreated)"

    return displayString
  }

  internal func validateIPAddress(ipAddress: String) -> Bool {
    return (ipAddress as NSString).isValidIPAddress()
  }

  internal func resolveMACAddressFromIPAddress(ipAddress: String) -> Result<String> {

    var result: Result<String>!
    IPHelper.macAddressFromIPAddress(ipAddress) {
      (macAddress, error) in

      if macAddress != nil {
        result = .Success(Box(macAddress))
      } else {
        result = .Error(error)
      }
    }

    return result
  }

  internal func isReachableForLocalWiFi() -> Bool {
    var reachableWiFi = Reachability.reachabilityForLocalWiFi()
    var status = reachableWiFi.currentReachabilityStatus()
    return (status == .ReachableViaWiFi)
  }

  internal func isReachableForInternetConnection() -> Bool {
    var reachableWWAN = Reachability.reachabilityForInternetConnection()
    var status = reachableWWAN.currentReachabilityStatus()
    return (status == .ReachableViaWWAN)
  }

}