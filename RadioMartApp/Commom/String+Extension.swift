//
//  String+Extension.swift
//  RadioMartApp
//
//  Created by XMaster on 04.03.2024.
//

import Foundation

extension String {
    func validatorEmail() -> Bool {
        if self.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var l: String {
        
        return NSLocalizedString(self,
                          tableName: "Localizable",
                          bundle: LM.bundle,
                          value: "",
                          comment: "")
    }

}


