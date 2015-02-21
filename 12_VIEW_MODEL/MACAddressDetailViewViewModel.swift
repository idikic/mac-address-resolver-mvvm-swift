//
//  MACAddressDetailViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation
import Reachability

enum Result<T> {
  // This might not be a desired behaviour, BUT this is
  // the only way for now to have a enum used in the protocol as
  // a return type. Swfit need to know full layout size of the enum
  // at a compile time.
  //
  // More info at:
  //
  // http://owensd.io/2014/08/06/fixed-enum-layout.html
  case Success(@autoclosure() -> T)
  case Error(String)
}

class MACAddressDetailViewViewModel: MACAddressDetailViewModel {

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
    self.textFieldPlaceholderText = Observable("tap to start")
    self.buttonTitle = Observable("LOOK UP")
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
      if countElements(textFieldText.value) == 6 {
        macAddress = textFieldText.value + "00:00:00"
      } else {
        macAddress = textFieldText.value
      }
      if validateMACAddress(macAddress) {
        MACAddressStore.sharedStore.createItem(macAddress) {
            (macAddressItem) in
            println(macAddressItem)
        }
      } else {
        errorHandler(message: "Invalid MAC address")
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
                      self.textFieldText.value = macAddress()
                      self.buttonTitle.value = "LOOK UP"
                      self.segmentedControlSelectedSegment.value = 0
                    case .Error(let error): errorHandler(message: error)
                }
              } else {
                errorHandler(message: "Destination host unreachable")
              }
          }
        } else {
          errorHandler(message: "Invalid IP address")
        }
      } else {
        errorHandler(message: "No local WiFi connection")
      }
    }
  }

  // MARK: UISegmented Control
  func segmentedControlDidSelectSegment(selectedSegment: Int) {
    segmentedControlSelectedSegment.value = selectedSegment

    switch selectedSegment {
    case 0:
      buttonTitle.value = "LOOK UP"
    case 1:
      buttonTitle.value = "RESOLVE IP ADDRESS"
    case 2:
      buttonTitle.value = "LOOK UP"
    default:
      return
    }
  }

  // MARK: Internal Helpers
  func validateMACAddress(macAddress: String) -> Bool {
    return macAddress =~ kValidMACAddressRegex
  }

  func validateIPAddress(ipAddress: String) -> Bool {
    return (ipAddress as NSString).isValidIPAddress()
  }

  func resolveMACAddressFromIPAddress(ipAddress: String) -> Result<String> {

    var result: Result<String>!
    IPHelper.macAddressFromIPAddress(ipAddress) {
      (macAddress, error) in

      if macAddress != nil {
        result = .Success(macAddress)
      } else {
        result = .Error(error)
      }
    }

    return result
  }

  func isReachableForLocalWiFi() -> Bool {
    var reachableWiFi = Reachability.reachabilityForLocalWiFi()
    var status = reachableWiFi.currentReachabilityStatus()
    return (status == .ReachableViaWiFi)
  }

  func isReachableForInternetConnection() -> Bool {
    var reachableWWAN = Reachability.reachabilityForInternetConnection()
    var status = reachableWWAN.currentReachabilityStatus()
    return (status == .ReachableViaWWAN)
  }

}