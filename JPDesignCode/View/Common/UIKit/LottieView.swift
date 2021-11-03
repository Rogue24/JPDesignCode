//
//  LottieView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/8/29.
//

import SwiftUI
import Lottie

/// 遵守 UIViewRepresentable，可以使用UIKit的视图
struct LottieView: UIViewRepresentable {
    var filename: String
    
    /// 创建视图
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        let anim = Lottie.Animation.named(filename)
        let animView = AnimationView()
        animView.animation = anim
        animView.contentMode = .scaleAspectFit
        animView.play()
        
        animView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animView)
        
        NSLayoutConstraint.activate([
            animView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        return view
    }
    
    /// 刷新视图
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
