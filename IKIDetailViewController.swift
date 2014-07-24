//
//  IKIDetailViewController.swift
//  M.A.C.
//
//  Created by iki on 20/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import AVFoundation

class IKIDetailViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,ScannerViewDelegate {
    
    // # pragma mark - Properties
    let macAddressItem: MACAddressItem?
   
    
    // # pragma mark - Outlets
    @IBOutlet weak var segmentedControlInputTypes: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonLookUp: UIButton!
    @IBOutlet weak var textViewResults: UITextView!
    
    
    // # pragma mark - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureDefaultSegmentedControl()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // SETUP SCANNER VIEW CONTROLLER
        var scannerViewController = segue.destinationViewController as IKIScannerViewController
        scannerViewController.delegate = self
        
        
    }
    
    /*
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        

    }
    */
    
    // # pragma mark - ACTION
    @IBAction func dismissDetailViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {
            
                () -> Void in
            
                println("Detail View Controller Dismissed")
            
            
            })
        
    }
    
    func selectedSegmentDidChange(segmentedControl: UISegmentedControl) {
        
        NSLog("The selected segment changed for: \(segmentedControl).")
        
        if segmentedControl.selectedSegmentIndex == 2 {
        
            var isCamera = UIImagePickerController.isCameraDeviceAvailable(.Rear)
            
            if !isCamera {
                
                let alert = UIAlertController(title: "WARNING", message: "No available camera", preferredStyle: .Alert)
                let actionOK = UIAlertAction(title: "OK", style: .Default, handler: {
                    
                    (action: UIAlertAction!) -> Void in
                    
                    alert .dismissViewControllerAnimated(true, completion: nil)
                    
                    })
                
                alert.addAction(actionOK)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                performSegueWithIdentifier("BarcodeScannerSegue", sender: segmentedControl)
               
            }
        }
        
    }
    
    // # pragma mark - Configuration
    func configureDefaultSegmentedControl() {
        
        segmentedControlInputTypes.momentary = true
        
        segmentedControlInputTypes.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: .ValueChanged)
        
    }
    
    // #pragma mark - Scanner View Delegate
    func didFinishedScanningMacAddress(macAddress: String?) {
    
        textField.text = macAddress
        
    }
}
