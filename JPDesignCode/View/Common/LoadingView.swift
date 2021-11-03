//
//  LoadingView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/8/29.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            LottieView(filename: "loading")
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red.opacity(0.000000001))
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
