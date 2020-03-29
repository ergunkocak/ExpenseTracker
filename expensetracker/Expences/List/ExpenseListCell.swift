//
//  ExpenseListCell.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import SwiftDate

class ExpenseListCell: UITableViewCell {
    
    static let reuseIdentifier = "expenseCell"
    
    var expense: ExpenseRecord! {
        didSet {
            updateValues()
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        accessoryView = nil
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let sideMargin: CGFloat = 16

    func layout() {
        [
            categoryLabel,
            dateLabel,
            amountLabel
        ].forEach(contentView.addSubview(_:))
        
        categoryLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.centerY).offset(-4)
            make.leading.equalToSuperview().offset(sideMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY).offset(-4)
            make.leading.equalTo(categoryLabel.snp.leading)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-sideMargin)
        }
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
    }

    let currencyFormatter = NumberFormatter()
    func updateValues() {
        var amount = NSDecimalNumber(value: expense.amount).multiplying(byPowerOf10: -2)
        if let incomeCategoryId = expense.incomeCategoryId {
            categoryLabel.text = incomeCategories.value.filter({ $0.id == incomeCategoryId}).first?.name ?? "???"
            amountLabel.textColor = .green
        } else if let expenseCategoryId = expense.expenseCategoryId {
            categoryLabel.text = expenseCategories.value.filter({ $0.id == expenseCategoryId}).first?.name ?? "???"
            amount = amount.multiplying(by: NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true))
            amountLabel.textColor = .red
        }
        if let created = expense.createdTS {
            let date = Date(timeIntervalSince1970: created)
            dateLabel.text = date.toRelative()
        } else {
            dateLabel.text = "\(expense.createdTS ?? -1)"
        }
        
        amountLabel.text = currencyFormatter.string(from: amount)!
    }
}
