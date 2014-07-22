//
//  IKIDetailViewController.swift
//  M.A.C.
//
//  Created by iki on 20/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class IKIDetailViewController: UIViewController {

    let macAddressItem: MACAddressItem?
    
    @IBOutlet weak var segmentedControlInputTypes: UISegmentedControl!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonLookUp: UIButton!
    @IBOutlet weak var textViewResults: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // # pragma mark - ACTION
    @IBAction func dismissDetailViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {
            
                () -> Void in
            
                println("Detail View Controller Dismissed")
            
            
            })
        
    }
    
    // # pragma mark - UI SEGMENTED CONTROL
    func configureSegmentedControl () {
    
        self.segmentedControlInputTypes.targetForAction("segmentedControlAction:", withSender: self.segmentedControlInputTypes)
    
    }
    
    func segmentedControlAction(segmentedControl: UISegmentedControl) {
    
        // Clean up
        self.textField.text = ""
        self.textField.resignFirstResponder()
        
        if segmentedControl.selectedSegmentIndex == 2 {
        
            self.textField.enabled = false
            
            
            
            
        }
        
        
        
    }


}
