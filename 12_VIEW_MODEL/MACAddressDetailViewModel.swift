//
//  MACAddressDetailViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACAddressDetailViewModel {

  var textFieldTextLength: Observable<Int> { get }

  var viewTitle: Observable<String> { get }
  var macAddressItem: Observable<MACAddressItem?> { get }
  var segmentedControlSelectedSegment: Observable<Int> { get }
  var pickerViewData: Observable<[String]> { get }
  var textFieldText: Observable<String> { get }
  var textFieldPlaceholderText: Observable<String> { get }
  var textViewText: Observable<String> { get }
  var buttonTitle: Observable<String> { get }

  // MARK: UITextField
  func textFieldTextLength(length: Int)
  func textFieldTextDidChange(newText: String)

  // MARK: UIPickerView
  func numberOfComponentsInPickerView() -> Int
  func numberOfRowsInComponentInPickerView() -> Int
  func pickerView(titleForRow row: Int) -> String
  func pickerView(didSelectRow row: Int, inComponent component: Int)

  // MARK: UISegmentedControl
  func segmentedControlDidSelectSegment(selectedSegment: Int)

  // MARK:
  func resolve(errorHandler:(message: String?) -> ())

  // MARK: Internal Helpers
  func validateMACAddress(macAddress: String) -> Bool
  func formatMACAddressForPickerView(macAddress: String) -> String
  func prepareMACAddressItemForDisplay(resultMACAddressItem: MACAddressItem) -> String
  func validateIPAddress(ipAddress: String) -> Bool
  func resolveMACAddressFromIPAddress(ipAddress: String) -> Result<String>
  func isReachableForLocalWiFi() -> Bool
  func isReachableForInternetConnection() -> Bool

}