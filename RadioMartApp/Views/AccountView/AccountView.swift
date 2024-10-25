//
//  AccountView.swift
//  RadioMartApp
//
//  Created by XMaster on 05.03.2024.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        if AuthService.shared.currentUser != nil {
            HomeAccountView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    AccountView()
}
