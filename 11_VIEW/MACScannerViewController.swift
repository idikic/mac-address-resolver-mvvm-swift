//
//  IKIScannerViewController.swift
//  M.A.C.
//
//  Created by iki on 22/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import AVFoundation

class MACScannerViewController: UIViewController {

  var macAddress: String?
  var viewModel: MACScannerViewViewModel!

  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(viewModel != nil, "VIEW MODEL CAN'T BE NIL")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    bindToViewModel()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
  }

  // MARK: Binding
  private func bindToViewModel() {
    view.layer.addSublayer(viewModel.previewLayer)
    viewModel.startScanningBarcode() {
      (macAddress) in
      println(macAddress)
    }
  }
}
