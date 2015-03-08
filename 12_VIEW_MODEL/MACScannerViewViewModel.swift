//
//  MACScannerViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 01/03/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

class MACScannerViewViewModel {

  private (set) var viewTitle: Observable<String> = Observable("XX:XX:XX:XX:XX:XX")
  func barcodeScanned(macAddress: String) {
    viewTitle.value = macAddress
  }
}