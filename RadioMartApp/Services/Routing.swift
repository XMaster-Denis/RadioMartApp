//
//  Routing.swift
//  RadioMartApp
//
//  Created by XMaster on 10.10.2023.
//

import SwiftUI

class Router: ObservableObject {
    public static var shared: Router = Router()
    @Published var catalogPath: NavigationPath = NavigationPath()
    @Published var projectsPath: NavigationPath = NavigationPath()
    private init(){}
}
