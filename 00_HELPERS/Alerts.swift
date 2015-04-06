//
//  Alerts.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 10/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
  
  class func showAlert(viewController: UIViewController, message: String?) {
    if let messageToDisplay = message {
      let alertController = UIAlertController(title: "",
                                              message: messageToDisplay,
                                              preferredStyle: .Alert)
      let cancelAction = UIAlertAction(title: "OK", style: .Cancel) {
        (action) in
      }
      alertController.addAction(cancelAction)
      viewController.presentViewController(alertController,
                                           animated: true,
                                           completion: nil)
    }
  }
}
