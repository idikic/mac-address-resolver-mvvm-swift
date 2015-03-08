//
//  MACScannerViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 01/03/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACScannerViewModel {

  var viewTitle: Observable<String> { get }
  func barcodeScanned(macAddress: String)

}