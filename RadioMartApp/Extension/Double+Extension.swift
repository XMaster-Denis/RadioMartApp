//
//  Double+Extension.swift
//  RadioMartApp
//
//  Created by XMaster on 21.12.2023.
//

import Foundation



extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "kz")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let formattedAmount = formatter.string(from: NSNumber(value: self))!
        return formattedAmount
    }

}

