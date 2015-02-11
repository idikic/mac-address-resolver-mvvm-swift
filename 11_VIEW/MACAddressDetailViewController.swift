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

    var viewModel: MACAddressDetailViewViewModel?

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedViewModel = viewModel {
            bindToViewModel()
        }
    }

    private func bindToViewModel() {
        viewModel!.macAddressItem.bindAndFire {
            [unowned self] in
            self.macAddressItem = $0
        }

        viewModel!.textFieldText.bindAndFire {
            [unowned self] in
            self.textField.text = $0
        }

        viewModel!.textFieldPlaceholderText.bindAndFire {
            [unowned self] in
            self.textField.placeholder = $0
        }

        viewModel!.buttonTitle.bindAndFire {
            [unowned self] in
            self.button.setTitle($0, forState: UIControlState.Normal)
        }

        viewModel!.textViewText.bindAndFire {
            [unowned self] in
            self.textView.text = $0
        }
    }
}

// MARK: UIPicker View Delegate
extension MACAddressDetailViewController: UIPickerViewDelegate {

}
