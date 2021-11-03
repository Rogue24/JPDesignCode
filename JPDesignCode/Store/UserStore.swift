//
//  UserStore.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/9/14.
//

import SwiftUI
import Combine

class UserStore: ObservableObject {
    @Published var isLogged: Bool = true
//    UserDefaults.standard.bool(forKey: "isLogged") {
//        didSet {
//            UserDefaults.standard.set(isLogged, forKey: "isLogged")
//            UserDefaults.standard.synchronize()
//        }
//    }
    @Published var showLogin = false
}
