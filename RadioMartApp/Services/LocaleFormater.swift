//
//  LocaleFormater.swift
//  RadioMartApp
//
//  Created by XMaster on 11.10.2023.
//

import Foundation

class NumberFormat {
    static public let currencyFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .currency
        result.maximumFractionDigits = 0
        result.locale = Locale(identifier: "kk_Cyrl_KZ")
        return result
    }()
    init () {
        //currencyFormatter.
    }
}

extension Decimal {
    func toLocateCurrencyString() -> String {
        return NumberFormat.currencyFormatter.string(from: NSDecimalNumber(decimal: self)) ?? "0.0"
    }
}
