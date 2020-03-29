//
//  ExpenseAddVC.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import SnapKit

class ExpenseAddVC: UIViewController {
    
    var presenter: ExpenseAddPresenter!
    
    lazy var typeSegment: UISegmentedControl = {
        let item = UISegmentedControl()
        item.insertSegment(withTitle: "add-type-income".localized(), at: 0, animated: false)
        item.insertSegment(withTitle: "add-type-expence".localized(), at: 1, animated: false)
        item.selectedSegmentIndex = 0
        return item
    }()
    
    lazy var accountPicker: UIPickerView = {
        let item = UIPickerView()
        item.delegate = self
        item.dataSource = self
        item.showsSelectionIndicator = true
        item.tag = accountTag
        return item
    }()
    
    lazy var accountInput: UITextField = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        let doneButton = UIBarButtonItem(title: "add-done".localized(), style: .plain, target: self, action: #selector(onAccountPickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flexSpace, doneButton]
        
        let item = UITextField()
        item.delegate = self
        item.placeholder = "add-account-input-placeholder".localized()
        item.borderStyle = .roundedRect
        item.inputView = accountPicker

        item.inputAccessoryView = toolbar
        toolbar.sizeToFit()
        
        accountPicker.reloadAllComponents()

        return item
    }()

    lazy var categoryPicker: UIPickerView = {
        let item = UIPickerView()
        item.delegate = self
        item.dataSource = self
        item.showsSelectionIndicator = true
        item.tag = categoryTag
        return item
    }()
    
    lazy var categoryInput: UITextField = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        let doneButton = UIBarButtonItem(title: "add-done".localized(), style: .plain, target: self, action: #selector(onCategoryPickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flexSpace, doneButton]
        
        let item = UITextField()
        item.delegate = self
        item.placeholder = "add-category-input-placeholder".localized()
        item.borderStyle = .roundedRect
        item.inputView = categoryPicker

        item.inputAccessoryView = toolbar
        toolbar.sizeToFit()

        categoryPicker.reloadAllComponents()

        return item
    }()

    lazy var amountInput: UITextField = {
        let item = UITextField()
        item.delegate = self
        item.placeholder = "add-amount-input-placeholder".localized()
        item.borderStyle = .roundedRect
        item.keyboardType = .decimalPad
        return item
    }()
    
    private let sideMargin: CGFloat = 16
    private let verticalSpacingForInputs: CGFloat = 16
    private let accountTag: Int = 100
    private let categoryTag: Int = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "add-page-title".localized()
        view.backgroundColor = .white
        setupNavigation()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        accountPicker.reloadAllComponents()
//        categoryPicker.reloadAllComponents()
        debugPrint(presenter.accounts)
        debugPrint(presenter.expenseCategories)
    }
    
    func setupNavigation() {
        let buttonDone = UIBarButtonItem(title: "add-done".localized(), style: .plain, target: self, action: #selector(onDone))
        navigationItem.rightBarButtonItem  = buttonDone

        let buttonCancel = UIBarButtonItem(title: "add-cancel".localized(), style: .plain, target: self, action: #selector(onCancel))
        navigationItem.leftBarButtonItem  = buttonCancel
    }
    
    func setupLayout() {
        edgesForExtendedLayout = []
        [
            typeSegment,
            accountInput,
            categoryInput,
            amountInput
        ].forEach(view.addSubview(_:))
        
        typeSegment.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(sideMargin)
            make.centerX.equalToSuperview()
        }
        
        accountInput.snp.makeConstraints { make in
            make.top.equalTo(typeSegment.snp.bottom).offset(verticalSpacingForInputs)
            make.leading.equalToSuperview().offset(sideMargin)
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(44)
        }
        
        categoryInput.snp.makeConstraints { make in
            make.top.equalTo(accountInput.snp.bottom).offset(verticalSpacingForInputs)
            make.leading.equalToSuperview().offset(sideMargin)
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(44)
        }
        
        amountInput.snp.makeConstraints { make in
            make.top.equalTo(categoryInput.snp.bottom).offset(verticalSpacingForInputs)
            make.leading.equalToSuperview().offset(sideMargin)
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(44)
        }
    }
    
    @objc func onCancel() {
        dismiss()
    }
    
    @objc func onDone() {
        // TODO: verify form
        // TODO: save
        dismiss()
    }
    
    private func dismiss() {
        navigationController?.dismiss(animated: true, completion: {
            //
        })
    }
    
    @objc func onAccountPickerDone() {
        accountPicker.resignFirstResponder()
        accountInput.resignFirstResponder()
    }
    
    @objc func onCategoryPickerDone() {
        categoryPicker.resignFirstResponder()
        categoryInput.resignFirstResponder()
    }

}

extension ExpenseAddVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == accountTag {
            return presenter.accounts[row].name
        } else if pickerView.tag == categoryTag {
            return presenter.expenseCategories[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO:
    }
}

extension ExpenseAddVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == accountTag {
            return presenter.accounts.count
        } else if pickerView.tag == categoryTag {
            return presenter.expenseCategories.count
        }

        return 0
    }
}

extension ExpenseAddVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountInput {
            categoryInput.resignFirstResponder()
            amountInput.resignFirstResponder()
            return
        }
        
        if textField == categoryInput {
            accountInput.resignFirstResponder()
            amountInput.resignFirstResponder()
            return
        }
        
        if textField == amountInput {
            accountInput.resignFirstResponder()
            categoryInput.resignFirstResponder()
            return
        }
    }
    
}
