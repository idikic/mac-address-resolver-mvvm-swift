//
//  MACScannerViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 01/03/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

protocol MACScannerViewModel {

  func startScanningBarcode(completionHandler: String -> ())

}