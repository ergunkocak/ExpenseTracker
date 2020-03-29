//
//  ExpenseAddVC.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol ExpenseAddProtocol {
    func dismiss()
}

class ExpenseAddVC: UIViewController, ExpenseAddProtocol {

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

    lazy var incomeCategoryPicker: UIPickerView = {
        let item = UIPickerView()
        item.delegate = self
        item.dataSource = self
        item.showsSelectionIndicator = true
        item.tag = incomeCategoryTag
        return item
    }()
    
    lazy var incomeCategoryToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        let doneButton = UIBarButtonItem(title: "add-done".localized(), style: .plain, target: self, action: #selector(onIncomeCategoryPickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flexSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    lazy var incomeCategoryInput: UITextField = {

        let item = UITextField()
        item.delegate = self
        item.placeholder = "add-category-input-placeholder".localized()
        item.borderStyle = .roundedRect
        
        item.inputView = incomeCategoryPicker
        item.inputAccessoryView = incomeCategoryToolbar

        return item
    }()
    
    lazy var expenseCategoryPicker: UIPickerView = {
        let item = UIPickerView()
        item.delegate = self
        item.dataSource = self
        item.showsSelectionIndicator = true
        item.tag = expenseCategoryTag
        return item
    }()
    
    lazy var expenseCategoryToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        let doneButton = UIBarButtonItem(title: "add-done".localized(), style: .plain, target: self, action: #selector(onExpenseCategoryPickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flexSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    lazy var expenseCategoryInput: UITextField = {
        let item = UITextField()
        item.delegate = self
        item.placeholder = "add-category-input-placeholder".localized()
        item.borderStyle = .roundedRect
        
        item.inputView = expenseCategoryPicker
        item.inputAccessoryView = expenseCategoryToolbar

        return item
    }()

    lazy var categoryStack: UIStackView = {
        let item = UIStackView()
        item.axis = .vertical
        item.addArrangedSubview(incomeCategoryInput)
        item.addArrangedSubview(expenseCategoryInput)
        expenseCategoryInput.isHidden = true
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
    private let incomeCategoryTag: Int = 200
    private let expenseCategoryTag: Int = 300
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "add-page-title".localized()
        view.backgroundColor = .white
        setupNavigation()
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        incomeCategoryPicker.reloadAllComponents()
        expenseCategoryPicker.reloadAllComponents()
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
            categoryStack,
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
        
        incomeCategoryInput.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        expenseCategoryInput.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        categoryStack.snp.makeConstraints { make in
            make.top.equalTo(accountInput.snp.bottom).offset(verticalSpacingForInputs)
            make.leading.equalToSuperview().offset(sideMargin)
            make.trailing.equalToSuperview().offset(-sideMargin)
        }
        
        amountInput.snp.makeConstraints { make in
            make.top.equalTo(categoryStack.snp.bottom).offset(verticalSpacingForInputs)
            make.leading.equalToSuperview().offset(sideMargin)
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(44)
        }
    }
    
    func setupBindings() {
        amountInput.rx.text.distinctUntilChanged()
            .subscribe(
                onNext: { [weak self] (amount: String?) in
                    guard let vc = self else { return }
                    guard let _amount = amount, !_amount.isEmpty else { return }
                    
                    // TODO: check locale decimal seperator
                    
                    let amountNumber = NSDecimalNumber(string: _amount)
                    vc.presenter.amountRx.accept(amountNumber.multiplying(byPowerOf10: 2).int64Value)
                }
            )
        .disposed(by: disposeBag)
        
        typeSegment.rx.selectedSegmentIndex.distinctUntilChanged()
            .subscribe(
                onNext: { [weak self] (selectedIndex: Int) in
                    guard let vc = self else { return }
                    if selectedIndex == 0 {
                        vc.incomeCategoryInput.isHidden = false
                        vc.expenseCategoryInput.isHidden = true
                    } else {
                        vc.incomeCategoryInput.isHidden = true
                        vc.expenseCategoryInput.isHidden = false
                    }
                    vc.view.endEditing(true)
                }
            )
        .disposed(by: disposeBag)
    }
    
    // MARK: Main navigation
    
    @objc func onCancel() {
        dismiss()
    }
    
    @objc func onDone() {
        save()
    }
    
    func dismiss() {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: {
            //
        })
    }
    
    // MARK: Picker Actions
    
    @objc func onAccountPickerDone() {
        accountPicker.resignFirstResponder()
        accountInput.resignFirstResponder()
    }
    
    @objc func onIncomeCategoryPickerDone() {
        incomeCategoryPicker.resignFirstResponder()
        incomeCategoryInput.resignFirstResponder()
    }

    @objc func onExpenseCategoryPickerDone() {
        expenseCategoryPicker.resignFirstResponder()
        expenseCategoryInput.resignFirstResponder()
    }

    // MARK: Form related
    
    func save() {
        guard !typeSegment.isSelected else {
            alertError(from: self, message: "add-error-required-type".localized())
            return
        }
        
        guard nil != presenter.selectedAccount else {
            alertError(from: self, message: "add-error-required-account".localized())
            return
        }
        
        if typeSegment.selectedSegmentIndex == 0 {
            guard nil != presenter.selectedIncomeCategory else {
                alertError(from: self, message: "add-error-required-income-category".localized())
                return
            }
            
        } else {
            guard nil != presenter.selectedExpenseCategory else {
                alertError(from: self, message: "add-error-required-expense-category".localized())
                return
            }
            
        }
        
        guard !(amountInput.text ?? "").isEmpty else {
            alertError(from: self, message: "add-error-required-amount".localized())
            return
        }
        
        guard presenter.amountRx.value > 0 else {
            alertError(from: self, message: "add-error-invalid-amount".localized())
            return
        }
        
        if typeSegment.selectedSegmentIndex == 0 {
            presenter.addIncome()
        } else {
            presenter.addExpense()
        }
    }
    
    
}

extension ExpenseAddVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == accountTag {
            return presenter.accounts[row].name
        } else if pickerView.tag == incomeCategoryTag {
            return presenter.incomeCategories[row].name
        } else if pickerView.tag == expenseCategoryTag {
            return presenter.expenseCategories[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == accountTag {
            let account = presenter.accounts[row]
            presenter.selectedAccount = account
            accountInput.text = account.name
        } else if pickerView.tag == incomeCategoryTag {
            let incomeCategory = presenter.incomeCategories[row]
            presenter.selectedIncomeCategory = incomeCategory
            incomeCategoryInput.text = incomeCategory.name
        } else if pickerView.tag == expenseCategoryTag {
            let expenseCategory = presenter.expenseCategories[row]
            presenter.selectedExpenseCategory = expenseCategory
            expenseCategoryInput.text = expenseCategory.name
        }
    }
}

extension ExpenseAddVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == accountTag {
            return presenter.accounts.count
        } else if pickerView.tag == incomeCategoryTag {
            return presenter.incomeCategories.count
        } else if pickerView.tag == expenseCategoryTag {
            return presenter.expenseCategories.count
        }

        return 0
    }
}

extension ExpenseAddVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountInput {
            incomeCategoryInput.resignFirstResponder()
            expenseCategoryInput.resignFirstResponder()
            amountInput.resignFirstResponder()
            return
        }
        
        if textField == incomeCategoryInput {
            accountInput.resignFirstResponder()
            expenseCategoryInput.resignFirstResponder()
            amountInput.resignFirstResponder()
            return
        }
        
        if textField == expenseCategoryInput {
            accountInput.resignFirstResponder()
            incomeCategoryInput.resignFirstResponder()
            amountInput.resignFirstResponder()
            return
        }
        
        if textField == amountInput {
            accountInput.resignFirstResponder()
            incomeCategoryInput.resignFirstResponder()
            expenseCategoryInput.resignFirstResponder()
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == amountInput else { return true }
        let decimalSeperator = Locale.current.decimalSeparator ?? "."
        if string == decimalSeperator {
            if textField.text!.contains(decimalSeperator) {
                return false
            }
            if textField.text!.isEmpty {
                return false
            }
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newString.contains(decimalSeperator) {
            let numberParts = newString.split(separator: decimalSeperator.first!)
            if let newDecimalCount = numberParts.last?.count, numberParts.count == 2 {
                if newDecimalCount > 2 {
                    return false
                }
            }
        }
        
        return true
    }
}
