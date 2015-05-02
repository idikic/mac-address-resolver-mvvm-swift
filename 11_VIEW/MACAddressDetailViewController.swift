//
//  MACAddressDetailViewController.swift
//  M.A.C.
//
//  Created by iki on 08/02/15.
//  Copyright (c) 2015 Iki. All rights reserved.
//

import UIKit
import AVFoundation

class MACAddressDetailViewController: UIViewController {

  // MARK: Propertys
  @IBOutlet weak var segmentedControl: UISegmentedControl! {
    didSet {
      segmentedControl.addTarget(self,
                                 action: Selector("segmentedControlDidSelectSegment:"),
                                 forControlEvents: .ValueChanged)
    }
  }

  @IBOutlet weak var textField: UITextField! {
    didSet {
      textField.layer.borderColor = UIColor(red:0.04,
                                            green:0.5,
                                            blue:1,
                                            alpha:1).CGColor
      textField.layer.borderWidth = Constants.UIGeometry.borderWidth as CGFloat
      textField.layer.cornerRadius = Constants.UIGeometry.cornerRadius as CGFloat
      textField.clearButtonMode = UITextFieldViewMode.Always
      textField.addTarget(self,
                          action: Selector("textFieldTextDidChange:"),
                          forControlEvents: UIControlEvents.EditingChanged)
    }
  }

  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var textView: UITextView! {
    didSet {
      textView.layer.borderColor = UIColor(red:0.04,
        green:0.5,
        blue:1,
        alpha:1).CGColor
      textView.layer.borderWidth = Constants.UIGeometry.borderWidth as CGFloat
      textView.layer.cornerRadius = Constants.UIGeometry.cornerRadius as CGFloat
    }
  }

  var macAddressItem: MACAddressItem?
  lazy var pickerView: UIPickerView = {
    var tempPickerView = UIPickerView()
    tempPickerView.delegate = self
    tempPickerView.showsSelectionIndicator = true
    return tempPickerView
  }()

  var viewModel: MACAddressDetailViewModel!

  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(viewModel != nil, "VIEW MODEL CAN'T BE NIL")

    // CONFIGURATION
    bindToViewModel()
  }

  // MARK: Binding
  private func bindToViewModel() {
    viewModel.viewTitle.bindAndFire {
      [unowned self] in
      self.title = $0
    }

    viewModel.macAddressItem.bindAndFire {
      [unowned self] in
      self.macAddressItem = $0
    }

    viewModel.segmentedControlSelectedSegment.bindAndFire {
      [unowned self] in
      self.segmentedControl.selectedSegmentIndex = $0

      self.textField.resignFirstResponder()
      self.textField.inputView = nil

      switch self.segmentedControl.selectedSegmentIndex {
      case 0:
        self.textField.inputView = self.pickerView

      case 1:
        self.textField.keyboardType = .NumbersAndPunctuation

      case 2:
        self.performSegueWithIdentifier(Constants.UISegue.barcodeScannerSegue,
                                        sender: self.segmentedControl)
      default:
        return
      }
    }

    viewModel.textFieldText.bindAndFire {
      [unowned self] in
      self.textField.text = $0
    }

    viewModel.textFieldPlaceholderText.bindAndFire {
      [unowned self] in
      self.textField.placeholder = $0
    }

    viewModel.buttonTitle.bindAndFire {
      [unowned self] in
      self.button.setTitle($0, forState: UIControlState.Normal)
    }

    viewModel.textViewText.bindAndFire {
      [unowned self] in
      self.textView.text = $0
    }
  }

  // MARK: User Action
  @IBAction func buttonLookUpAction(sender: UIButton) {
    viewModel.resolve() {
      [unowned self] (errorMessage) in
      Alerts.showAlert(self, message: errorMessage)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == Constants.UISegue.barcodeScannerSegue {
      var destinationViewController =
        segue.destinationViewController as! MACScannerViewController

      var destinationViewModel = MACScannerViewModel()
      destinationViewController.viewModel = destinationViewModel
    }
  }

  // MARK: Internal Helpers
  func textFieldTextDidChange(textField: UITextField!) {
    viewModel.textFieldTextDidChange(textField.text)
  }

  func segmentedControlDidSelectSegment(sender: UISegmentedControl!) {
    viewModel.segmentedControlDidSelectSegment(sender.selectedSegmentIndex)
  }
}

// MARK: UIPicker View Delegate
extension MACAddressDetailViewController: UIPickerViewDelegate {

  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return viewModel.pickerView(titleForRow: row)
  }

  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    viewModel.textFieldTextLength(count(textField.text))
    viewModel.textFieldTextDidChange(textField.text)
    return viewModel.pickerView(didSelectRow: row, inComponent: component)
  }
}

// MARK: UIPicker View Data Source
extension MACAddressDetailViewController: UIPickerViewDataSource {

  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return viewModel.numberOfComponentsInPickerView()
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return viewModel.numberOfRowsInComponentInPickerView()
  }
}
