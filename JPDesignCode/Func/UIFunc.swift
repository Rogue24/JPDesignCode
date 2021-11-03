//
//  UIFunc.swift
//  JPDesignCode
//
//  Created by aa on 2021/10/28.
//

import SwiftUI

func getCardWidth(with bounds: GeometryProxy) -> CGFloat {
    // 712是iPad端的弹窗视图建议的最大宽度
    guard bounds.size.width < 712 else {
        return 712
    }
    return bounds.size.width - 60
}

func getCardCornerRadius(with bounds: GeometryProxy) -> CGFloat {
    // 712是iPad端的弹窗视图建议的最大宽度
    if bounds.size.width < 712, bounds.safeAreaInsets.top < 44 {
        return 0
    }
    return 30
}

func haptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
