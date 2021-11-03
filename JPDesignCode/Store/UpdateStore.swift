//
//  UpdateStore.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/27.
//

import SwiftUI
import Combine

class UpdateStore: ObservableObject {
    @Published var updates: [Update] = updateData
}
