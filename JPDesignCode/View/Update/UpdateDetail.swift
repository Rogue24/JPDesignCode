//
//  UpdateDetail.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/27.
//

import SwiftUI

struct UpdateDetail: View {
    var update: Update
    
    var body: some View {
        List {
            VStack(spacing: 20) {
                Image(update.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                Text("\(update.text)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .listStyle(PlainListStyle())
        // 设置当前页面的导航栏标题
        // - 1.预览画面是不可见的，只有在导航控制器推出后才可见
        // - 2.要在最外层的视图添加才显示
        .navigationBarTitle(update.title)
    }
}

struct UpdateDetail_Previews: PreviewProvider {
    static var previews: some View {
        UpdateDetail(update: updateData[0])
    }
}
