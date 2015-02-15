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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!

    var macAddressItem: MACAddressItem?
    lazy var pickerView: UIPickerView = {
        var tempPickerView = UIPickerView()
        tempPickerView.delegate = self
        tempPickerView.showsSelectionIndicator = true
        return tempPickerView
    }()

    var viewModel: MACAddressDetailViewViewModel!

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil, "VIEW MODEL CAN'T BE NIL")

        // CONFIGURATION
        bindToViewModel()

        textField.inputView = pickerView
        textField.clearButtonMode = UITextFieldViewMode.Always
        textField.addTarget(self,
                            action: Selector("textFieldTextDidChange:"),
                            forControlEvents: UIControlEvents.EditingChanged)
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

        viewModel.enabled.bindAndFire {
            [unowned self] in
            self.textField.enabled = $0
            self.button.enabled = $0
            self.segmentedControl.enabled = $0
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
        viewModel.resolve(segmentedControl.selectedSegmentIndex) {
            [unowned self] (errorMessage) in
            Alerts.showAlert(self, message: errorMessage)
        }
    }

    // MARK: Internal Helpers
    func textFieldTextDidChange(textField: UITextField!) {
        viewModel.textFieldTextDidChange(textField.text)
    }
}

// MARK: UIPicker View Delegate
extension MACAddressDetailViewController: UIPickerViewDelegate {

    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return viewModel.pickerView(titleForRow: row)
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.textFieldTextLength(countElements(textField.text))
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
