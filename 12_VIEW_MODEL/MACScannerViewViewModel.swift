//
//  MACScannerViewViewModel.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 01/03/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import Foundation
import AVFoundation

/**
*  Quick rundown of the instance variables (via 'iOS 7 By Tutorials'):
*
*   captureSession – AVCaptureSession is the core media handling class in AVFoundation.
*     It talks to the hardware to retrieve, process, and output video.
*     A capture session wires together inputs and outputs,
*     and controls the format and resolution of the output frames.
*
*   captureVideoDevice – AVCaptureDevice encapsulates the physical camera on a device.
*     Modern iPhones have both front and rear cameras, while other devices may only have a single camera.
*
*   captureDeviceInput – To add an AVCaptureDevice to a session, wrap it in an AVCaptureDeviceInput.
*     A capture session can have multiple inputs and multiple outputs.
*
*   previewLayer – AVCaptureVideoPreviewLayer provides a mechanism for displaying
*     the current frames flowing through a capture session; 
*     it allows you to display the camera output in your UI.
*
*   running – This holds the state of the session; either the session is running or it’s not.
*
*   metadataOutput - AVCaptureMetadataOutput provides a callback to the application
*     when metadata is detected in a video frame. AV Foundation supports two types of metadata:
*     machine readable codes and face detection.
*/

enum ScannerSessionAvailable {
  case Success
  case Error(String)
}

class MACScannerViewViewModel: NSObject,
                               MACScannerViewModel {

  typealias ScannerCompletionHandler = String -> ()

  private (set) var previewLayer: AVCaptureVideoPreviewLayer?
  private (set) var allowedBarcodeTypes = [
    "org.iso.QRCode",
    "org.iso.PDF417",
    "org.gs1.UPC-E",
    "org.iso.Aztec",
    "org.iso.Code39",
    "org.iso.Code39Mod43",
    "org.gs1.EAN-13",
    "org.gs1.EAN-8",
    "com.intermec.Code93",
    "org.iso.Code128"
  ]

  private var completionHandler: ScannerCompletionHandler!
  private var captureSession: AVCaptureSession?
  private var captureVideoDevice: AVCaptureDevice?
  private var captureDeviceInput: AVCaptureDeviceInput?
  private var running: Bool
  private var captureMetadataOutput: AVCaptureMetadataOutput?

  init?(frameForCameraPreviewLayer frame: CGRect) {
    self.running = false

    super.init()

    switch self.setupCaptureSession() {
      case .Success:
        self.previewLayer!.frame = frame;
      case .Error(let error):
        println(error)
        return nil
    }
  }

  // MARK: Internal Helpers
  private func setupCaptureSession() -> ScannerSessionAvailable {
    if (self.captureSession != nil) {
      return .Error("Scanner Session Already Initialized")
    }
    self.captureVideoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    if (self.captureVideoDevice == nil) {
      return .Error("No Usable Video Camera Available On This Device")
    }
    self.captureSession = AVCaptureSession()
    var errorCaptureDeviceInput = NSErrorPointer()
    self.captureDeviceInput = AVCaptureDeviceInput(device: self.captureVideoDevice,
                                                   error: errorCaptureDeviceInput)
    if self.captureSession!.canAddInput(self.captureDeviceInput) {
      self.captureSession!.addInput(self.captureDeviceInput)
    }
    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
    self.captureMetadataOutput = AVCaptureMetadataOutput()
    self.captureMetadataOutput!.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    if self.captureSession!.canAddOutput(self.captureMetadataOutput) {
      self.captureSession!.addOutput(self.captureMetadataOutput)
    }

    return .Success
  }

  private func startRunning(){
    if self.running {
      return
    }
    self.captureSession?.startRunning()
    self.captureMetadataOutput!.metadataObjectTypes = self.captureMetadataOutput?.availableMetadataObjectTypes
    self.running = true
  }

  private func stopRunning() {
    if !self.running {
      return
    }
    self.captureSession!.stopRunning()
    self.running = false
  }

  // MARK: Notifications
  private func applicationWillEnterForeground(note: NSNotification) -> Void {
    self.startRunning()
  }

  private func applicationDidEnterBackground(note: NSNotification) -> Void {
    self.stopRunning()
  }

  // MARK: Public methods
  func startScanningBarcode(completionHandler: ScannerCompletionHandler) {
    self.completionHandler = completionHandler;
    startRunning()
  }
}

// MARK: AVCapture Delegate
extension MACScannerViewViewModel: AVCaptureMetadataOutputObjectsDelegate {
  func captureOutput(captureOutput: AVCaptureOutput!,
                     didOutputMetadataObjects metadataObjects: [AnyObject]!,
                     fromConnection connection: AVCaptureConnection!) {

    for object in metadataObjects {
      if object.isKindOfClass(AVMetadataMachineReadableCodeObject) {
        let transformedMetaDataObject =
          self.previewLayer?.transformedMetadataObjectForMetadataObject(object as AVMetadataObject)

        let barcodeCode = transformedMetaDataObject as AVMetadataMachineReadableCodeObject
        self.completionHandler(barcodeCode.stringValue)
        stopRunning()
        return
      }
    }
  }
}
