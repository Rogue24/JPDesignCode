//
//  BlurView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/8/8.
//

import SwiftUI

/// 遵守 UIViewRepresentable，可以使用UIKit的视图
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    /// 创建视图
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        return view
    }
    
    /// 刷新视图
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
