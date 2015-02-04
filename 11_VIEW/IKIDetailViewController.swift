//
//  IKIDetailViewController.swift
//  M.A.C.
//
//  Created by iki on 20/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import AVFoundation

class IKIDetailViewController:  UIViewController,
                                AVCaptureMetadataOutputObjectsDelegate,
                                ScannerViewDelegate,
                                UIPickerViewDelegate, UIPickerViewDataSource
    
{
    
    // MARK: - Properties
    let macAddressItem: MACAddressItem?
    
    let macAddressSpinnerData = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
    lazy var macAddressSpinner: UIPickerView = {
        
        var tempMacAddressSpinner = UIPickerView()
        
        tempMacAddressSpinner.delegate = self
        tempMacAddressSpinner.showsSelectionIndicator = true
    
        return tempMacAddressSpinner
    }()
    
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControlInputTypes: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonLookUp: UIButton!
    @IBOutlet weak var textViewResults: UITextView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureDefaultSegmentedControl()
        self.textField.inputView = self.macAddressSpinner
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
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
    
    // MARK: - UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.macAddressSpinnerData.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.macAddressSpinnerData[component]
    }
    
    // MARK: - Action
    @IBAction func dismissDetailViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {
            
                () -> Void in
            
                println("Detail View Controller Dismissed")
            
            
            })
        
    }
    
    func selectedSegmentDidChange(segmentedControl: UISegmentedControl) {
        
        NSLog("The selected segment changed for: \(segmentedControl).")
        
        //Clear all input views for textField
        self.textField.inputView = nil
        self.textField.resignFirstResponder()
        
        if segmentedControl.selectedSegmentIndex == 2 {
        
            self.buttonLookUp.setTitle("LOOK UP MAC ADDRESS", forState: UIControlState.Normal)
            var isCamera = UIImagePickerController.isCameraDeviceAvailable(.Rear)
            
            if !isCamera {
                
                alertView("WARNING", message: "NO AVAILABLE CAMERA")
                segmentedControlInputTypes.selectedSegmentIndex = 0
            
            } else {
                
                performSegueWithIdentifier("BarcodeScannerSegue", sender: segmentedControl)
               
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
        
            self.textField.placeholder = "enter IP address of desired device"
            self.buttonLookUp.setTitle("TRY TO EXTRACT MAC ADDRESS FROM IP", forState: UIControlState.Normal)
        
        } else if segmentedControl.selectedSegmentIndex == 0 {
        
                textField.placeholder = "enter MAC address of desired device"
                textField.inputView = macAddressSpinner
            
                self.buttonLookUp.setTitle("LOOK UP MAC ADDRESS", forState: UIControlState.Normal)
        
        }
        
        
    }
    
    @IBAction func buttonDownload(sender: AnyObject) {
        
        if segmentedControlInputTypes.selectedSegmentIndex == 0 || segmentedControlInputTypes.selectedSegmentIndex == 2 {
        
            if validateMACAddress(self.textField.text) {
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//                let downloader = Downloader(url: macAddressResolverURL + self.textField.text)
//                downloader.downloadJSON() {
//                    
//                    (let arrayOfDictionaryObjects) in
//                    
//                    
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    println(arrayOfDictionaryObjects)
//                    
//                    self.textViewResults.text = "\(arrayOfDictionaryObjects)"
//                }

                
            } else {
                
                self .alertView("WARNING", message: "INVALID MAC ADDRESS")

            }
        
        
        } else if segmentedControlInputTypes.selectedSegmentIndex == 1 {
        
            if validateIPAddress(self.textField.text) {
                
                SimplePingHelper.ping(self.textField.text, target: self, sel: "pingResults:")
                
            } else {
                
                self .alertView("WARNING", message: "INVALID IP ADDRESS")
                
            }
        
        }
        
    
    }
    
    
    // MARK: - Validation
    func validateMACAddress(inputString: String) -> Bool {
    
        var validMACAddress = inputString.isValidMacAddress(inputString)
        
        println("MAC ADDRESS: \(validMACAddress)")
        
        return validMACAddress
    
    }
    
    func validateIPAddress(inputString: String) -> Bool {
    
        var validIPAddress = (inputString as NSString).isValidIPAddress()
        
        println("IP ADDRESS: \(validIPAddress)")
        
        return validIPAddress

    }
    
    // MARK: - Configuration
    func configureDefaultSegmentedControl() {
        
        segmentedControlInputTypes.momentary = false
        segmentedControlInputTypes.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: .ValueChanged)
        
    }
    
    // MARK: - Scanner View Delegate
    func didFinishedScanningMacAddress(macAddress: String?) {
    
        textField.text = macAddress
        
    }
    
    // MARK: - Helpers
    func alertView(name: String, message: String) {
    
        var alert = UIAlertController(title: name, message: message, preferredStyle: .Alert)
        var actionOK = UIAlertAction(title: "OK", style: .Default, handler: {
            
            (action: UIAlertAction!) -> Void in
            
            alert .dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        alert.addAction(actionOK)
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func ipToMACAddressUsingARPtable(ipAddress: String) {
    
        var convertedIPAddress = NetworkUtility .convertIPAddress(self.textField.text)
        var macAddress = NetworkUtility .ip2mac(convertedIPAddress, withBlock:{
            
            (let error: String!) in
            
            self.alertView("WARNING", message: error)
            
            }
            
        )
        
        if let macAddressItem = macAddress {
            
            self.buttonLookUp.setTitle("LOOK UP MAC ADDRESS", forState: UIControlState.Normal)
            segmentedControlInputTypes.selectedSegmentIndex = 0
            
            self.textField.text = macAddressItem
            alertView("MAC ADDRESS RECIEVED", message: macAddressItem)
            
        }

    
    }
    
    func pingResults(number: NSNumber) {
    
        if number.boolValue {
        
            ipToMACAddressUsingARPtable(textField.text)
        
        } else {
        
            alertView("WARNING", message: "UNABLE TO REACH DEVICE")
        }
    
    }
    
    
}
