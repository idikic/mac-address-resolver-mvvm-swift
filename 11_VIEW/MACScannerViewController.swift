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
  var macScanner: Scanner?
  var viewModel: MACScannerViewViewModel!

  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(viewModel != nil, "VIEW MODEL CAN'T BE NIL")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)

    macScanner = Scanner(frameForCameraPreviewLayer: self.view.frame)
    view.layer.addSublayer(macScanner?.previewLayer)

    bindToViewModel()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
  }

  // MARK: Binding
  private func bindToViewModel() {
    macScanner?.startScanningBarcode() {
      [unowned self](macAddress) in
      println(macAddress)
      self.viewModel.barcodeScanned(macAddress)
    }
  }
}
