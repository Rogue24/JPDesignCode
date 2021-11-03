//
//  TabBar.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/27.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            Home().tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            CourseList().tabItem {
                Image(systemName: "rectangle.stack.fill")
                Text("Courses")
            }
        }
//        .edgesIgnoringSafeArea(.top)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        // 添加不同设备进行预览
        Group {
            TabBar().previewDevice("iPhone 8")
            TabBar().previewDevice("iPhone 11 Pro Max")
        }
    }
}
