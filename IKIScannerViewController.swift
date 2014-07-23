//
//  IKIScannerViewController.swift
//  M.A.C.
//
//  Created by iki on 22/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

/* Here’s a quick rundown of the instance variables (via 'iOS 7 By Tutorials'):

1.  captureSession – AVCaptureSession is the core media handling class in AVFoundation. It talks to the hardware to retrieve, process, and output video. A capture session wires together inputs and outputs, and controls the format and resolution of the output frames.

2.  captureVideoDevice – AVCaptureDevice encapsulates the physical camera on a device. Modern iPhones have both front and rear cameras, while other devices may only have a single camera.

3.  captureDeviceInput – To add an AVCaptureDevice to a session, wrap it in an AVCaptureDeviceInput. A capture session can have multiple inputs and multiple outputs.

4.  previewLayer – AVCaptureVideoPreviewLayer provides a mechanism for displaying the current frames flowing through a capture session; it allows you to display the camera output in your UI.
5.  running – This holds the state of the session; either the session is running or it’s not.
6.  metadataOutput - AVCaptureMetadataOutput provides a callback to the application when metadata is detected in a video frame. AV Foundation supports two types of metadata: machine readable codes and face detection.

*/

import UIKit
import AVFoundation

class IKIScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var macAddress: String?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var captureVideoDevice: AVCaptureDevice?
    var captureDeviceInput: AVCaptureDeviceInput?
    var running: Bool = false
    var captureMetadataOutput: AVCaptureMetadataOutput?
    var scannerSessionAvailable: Bool = false
    
    let allowedBarcodeTypes = ["org.iso.QRCode",
                                "org.iso.PDF417",
                                "org.gs1.UPC-E",
                                "org.iso.Aztec",
                                "org.iso.Code39",
                                "org.iso.Code39Mod43",
                                "org.gs1.EAN-13",
                                "org.gs1.EAN-8",
                                "com.intermec.Code93",
                                "org.iso.Code128"]
    
    
    // #pragma mark - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scannerSessionAvailable = self.setupCaptureSession()
        
        
        if self.scannerSessionAvailable {
            
            self.previewLayer!.frame = self.view.bounds
            self.view.layer.addSublayer(self.previewLayer)
        
        } else {
        
            
            println("UNABLE TO INITIALIZE A SCANNING SESSION")
        }

        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if self.scannerSessionAvailable {
             self.startRunning()
        }
       
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    
        if self.scannerSessionAvailable {
            self.stopRunning()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // #pragma mark - AV capture methods
    func setupCaptureSession() -> Bool {
    
        // 1.
        if self.captureSession {
            
            // SCANNER SESSION ALREADY INITIALIZED
            return false
        }
    
        // 2.
        self.captureVideoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
        if let videoDevice = self.captureVideoDevice {
            println("YES video camera on this device!");
        } else {
            println("NO video camera on this device!");
            
            // SCANNER SESSION NO COMPLETED SUCCESFULLY
            return false;
        
        }
        
        // 3.
        self.captureSession = AVCaptureSession()
        
        // 4.
        var errorCaptureDeviceInput = NSErrorPointer()
        self.captureDeviceInput = AVCaptureDeviceInput(device: self.captureVideoDevice, error: errorCaptureDeviceInput)
        
        // 5.
        if self.captureSession!.canAddInput(self.captureDeviceInput) {
            self.captureSession!.addInput(self.captureDeviceInput)
        
        }
        
        // 6.
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        self.captureMetadataOutput = AVCaptureMetadataOutput()
        self.captureMetadataOutput!.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        if self.captureSession!.canAddOutput(self.captureMetadataOutput) {
        
            self.captureSession!.addOutput(self.captureMetadataOutput)
        
        }
        
        // SCANNER SESSION SUCCESFULLY COMPLETED
        return true
    
    }
    
    func startRunning(){
    
        if self.running {
        
            return
        }
        
        self.captureSession?.startRunning()
        self.captureMetadataOutput!.metadataObjectTypes = self.captureMetadataOutput?.availableMetadataObjectTypes
        
        self.running = true
        
    }
    
    func stopRunning() {
    
        if !self.running {
        
            return
        }
        self.captureSession!.stopRunning()
        self.running = false
    
    }

    func applicationWillEnterForeground(note: NSNotification) -> Void {
    
        self.startRunning()
    
    }
    
    func applicationDidEnterBackground(note: NSNotification) -> Void {
        
        self.stopRunning()
        
    }
    
    // #pragma mark - Delegate functions
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
        for object in metadataObjects {
            
            if object.isKindOfClass(AVMetadataMachineReadableCodeObject) {
            
                let transformedMetaDataObject = self.previewLayer?.transformedMetadataObjectForMetadataObject(object as AVMetadataObject)
                
                let barcodeCode = transformedMetaDataObject as AVMetadataMachineReadableCodeObject
                
                // Process barcode
                self.validBarcodeFound(barcodeCode)
                
                return
                
            }
            
        }
    
    
    }

    func validBarcodeFound(barcode: AVMetadataMachineReadableCodeObject) {
    
        self.stopRunning()
        self.macAddress = barcode.stringValue
        
        let alert = UIAlertController(title: "BARCODE SUCCESFULLY SCANNED", message: self.macAddress, preferredStyle: .Alert)
        let actionOK = UIAlertAction(title: "OK", style: .Default, handler: {
            
            (action: UIAlertAction!) -> Void in
            
            alert .dismissViewControllerAnimated(true, completion: nil)
            
            })
        
        let actionContinueScanning = UIAlertAction(title: "Try again", style: .Default, handler: {
            
            (action: UIAlertAction!) -> Void in
        
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.startRunning()
            
            })
        
        alert.addAction(actionOK)
        alert.addAction(actionContinueScanning)
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    /*
    - (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    [self.foundBarcodes addObject:barcode];
    [self showBarcodeAlert:barcode];
    }
    
    */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
