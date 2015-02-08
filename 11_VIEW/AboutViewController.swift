//
//  IKIAboutViewController.swift
//  M.A.C.
//
//  Created by Ivan Dikic on 03/09/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let authorLinkedinURL = "http://www.linkedin.com/pub/ivan-dikic/37/430/932"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "About"
        var url = NSURL(string: authorLinkedinURL)
        var request = NSURLRequest(URL: url!)
        
        
        webView.delegate = self
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Web View
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        loadingEnd()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        loadingStart()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        loadingEnd()
    
    }

    func loadingStart() {
    
         UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    
    }
    
    func loadingEnd() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
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
