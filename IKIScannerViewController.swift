//
//  IKIScannerViewController.swift
//  M.A.C.
//
//  Created by iki on 22/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import AVFoundation

class IKIScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var macAddress: String?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var captureVideoDevice: AVCaptureDevice?
    var captureDeviceInput: AVCaptureDeviceInput?
    var running: Bool?
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
    
        if self.captureSession {
            
            // SCANNER SESSION ALREADY INITIALIZED
            return false
        }
    
        self.captureVideoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
        if let videoDevice = self.captureVideoDevice {
            println("YES video camera on this device!");
        } else {
            println("NO video camera on this device!");
            
            // SCANNER SESSION NO COMPLETED SUCCESFULLY
            return false;
        
        }
        
        self.captureSession = AVCaptureSession()
        
        var errorCaptureDeviceInput = NSErrorPointer()
        self.captureDeviceInput = AVCaptureDeviceInput(device: self.captureVideoDevice, error: errorCaptureDeviceInput)
        
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
            
                let code = self.previewLayer?.transformedMetadataObjectForMetadataObject(object as AVMetadataObject) as AVMetadataMachineReadableCodeObject
                    
                self.macAddress = code.stringValue

                
            }
            
        }
    
    
    }


    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
