//
//  Globals.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import RxCocoa

// Categories do not change and used every where so will keep them global
var accounts = BehaviorRelay<[AccountRecord]>(value: [])
var incomeCategories = BehaviorRelay<[IncomeCategoryRecord]>(value: [])
var expenseCategories = BehaviorRelay<[ExpenseCategoryRecord]>(value: [])
