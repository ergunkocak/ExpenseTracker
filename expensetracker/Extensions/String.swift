//
//  String.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import Foundation

extension String {
    func localized(_ comment: String = "") -> String {
        let translated = NSLocalizedString(self, comment: comment)
        if self.lowercased() != translated.localizedLowercase {
            return translated
        }
        return fallback(self, comment: comment)
    }
    
    private func fallback(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String {
        let fallbackLanguage = "en"
        guard let fallbackBundlePath = Bundle.main.path(forResource: fallbackLanguage, ofType: "lproj") else { return key }
        guard let fallbackBundle = Bundle(path: fallbackBundlePath) else { return key }
        return fallbackBundle.localizedString(forKey: key, value: comment, table: nil)
    }
}
