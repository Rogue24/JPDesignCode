//
//  JPDesignCodeApp.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/6.
//

import SwiftUI

@main
struct JPDesignCodeApp: App {
    /**
     * SwiftUI 中想要使用`AppDelegate`中的生命周期函数：
     * 1. 创建一个遵循`UIApplicationDelegate`的类（文件名为`AppDelegate`）
     * 2. 使用`UIApplicationDelegateAdaptor`属性修饰器，指定类型为`1`创建的`AppDelegate`
     * 参考：https://juejin.cn/post/6857786490400407566
     */
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
//            TabBar()
//            PostList()
//            TestView()
//            CourseList()
//            Buttons()
            
            /**
             * 配置整个应用程序中的所有视图共享的数据
             * 1. 在祖先视图设置`environmentObject`初始化环境对象
             * 2. 在需要用到的地方使用属性包装器获取环境对象 `@EnvironmentObject var user: UserStore`
             * 参考：https://www.jianshu.com/p/2bc6a9ba477d
             */
            Home().environmentObject(UserStore())
//            CourseList().environmentObject(UserStore())
//            TabBar().environmentObject(UserStore())
        }
    }
}
