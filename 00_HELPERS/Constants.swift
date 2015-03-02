//
//  Constants.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 22/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation

struct Constants {
  struct UIGeometry {
    static let borderWidth = NSNumber(integer: 1)
    static let cornerRadius = NSNumber(integer: 5)
  }

  struct UIString {
    static let buttonTitleLookUp = "LOOK UP"
    static let buttonTitleResolveIPAddress = "RESOLVE IP ADDRESS"

    static let messageInvalidIPAddress = "Invalid IP address"
    static let messageNoLocalWiFiConnection = "No local WiFi connection"
    static let messageDestinationHostUnreachable = "Destination host unreachable"
    static let messageInvalidMACAddress = "Invalid MAC address"
    static let messageGenericError = "Ooops, please try again :)"

    static let textFieldTapToStart = "tap to start"

    static let macAddressEmptySuffix = "00:00:00"
  }

  struct UISegue {
    static let barcodeScannerSegue = "BarcodeScannerSegue"
  }
}