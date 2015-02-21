//
//  MACAddressDetailViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACAddressDetailViewModel {

  var viewTitle: Observable<String> { get }
  var macAddressItem: Observable<MACAddressItem?> { get }
  var pickerViewData: Observable<[String]> { get }
  var textFieldText: Observable<String> { get }
  var textFieldPlaceholderText: Observable<String> { get }
  var textFieldTextLength: Observable<Int> { get }
  var segmentedControlSelectedSegment: Observable<Int> { get }
  var textViewText: Observable<String> { get }
  var buttonTitle: Observable<String> { get }

  func textFieldTextLength(length: Int)
  func textFieldTextDidChange(newText: String)
  func numberOfComponentsInPickerView() -> Int
  func numberOfRowsInComponentInPickerView() -> Int
  func pickerView(titleForRow row: Int) -> String
  func pickerView(didSelectRow row: Int, inComponent component: Int)
  func segmentedControlDidSelectSegment(selectedSegment: Int)

  func resolve(errorHandler:(message: String?) -> ())
  func validateMACAddress(macAddress: String) -> Bool
  func validateIPAddress(ipAddress: String) -> Bool
  func resolveMACAddressFromIPAddress(ipAddress: String) -> Result<String>

}