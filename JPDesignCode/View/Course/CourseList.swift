//
//  CourseList.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/7/4.
//

import SwiftUI
import SDWebImageSwiftUI

struct CourseList: View {
//    @State var courses = courseData
    @ObservedObject var store = CourseStore()
    @State var active = false
    @State var finalActive = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                Color.black
                    .opacity(Double(activeView.height / 500))
                    .animation(.linear)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Courses")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .padding(.top, 30)
                            .blur(radius: active ? 20 : 0)
                        
                        // ForEach(xxx, id: \.aaa) --- xxx是个数组，这里的 \.aaa 是指 xxx[i].aaa，意思是将每个元素的aaa属性作为id（KeyPath）
                        // 例如：ForEach(courses, id: \.title) --- 这个id【应该】是用来作为标识，数据刷新时用到，所以最好不要用可能会重复的属性，这里只是举个例子
                        // ForEach(courses.indices, id: \.self) --- courses.indices：索引的半开区间 [0..<3]，\.self 则是返回自身，即 0、1、2
                        ForEach(store.courses.indices, id: \.self) { index in
                            GeometryReader { geometry in
                                CourseView(course: $store.courses[index],
                                           active: $active,
                                           finalActive: $finalActive,
                                           index: index,
                                           activeIndex: $activeIndex,
                                           activeView: $activeView,
                                           bounds: bounds)
                                    .offset(y: store.courses[index].show ? -geometry.frame(in: .global).minY : 0)
                                    .scaleEffect(active && activeIndex != index ? 0.5 : 1)
                                    .offset(x: active && activeIndex != index ? -bounds.size.width : 0)
                                    // 这两个自己加的
                                    .animation(
                                        finalActive ? nil : Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
                                    ) // 保证这以上的都有动画
                                    .opacity(
                                        (active && activeIndex != index || finalActive && activeIndex == index)
                                        ? 0 : 1
                                    )
                                    .animation(
                                        active && activeIndex != index ? Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0) : nil
                                    ) // 只让点击的那一个的opacity没有动画
                            }
                            // Multitasking Size Classes
                            // regular：常用型（这里会以类似钱包App那种卡片叠加的形式排列）
                            // compact：紧凑型（这里会以普通卡片紧挨着的形式排列）
                            // 在iPad横屏打开两个App时，App会有3种窗口宽度类型：1/3、1/2、2/3
                            // 当App宽度为窗口的 2/3 时，horizontalSizeClass为regular，而 1/2 和 1/3 则为compact
                            .frame(height: horizontalSizeClass == .regular ? 80 : 280)
                            // 这里的maxWidth不使用infinity了，712是iPad端的弹窗视图建议的最大宽度
                            .frame(maxWidth: self.store.courses[index].show ? 712 : getCardWidth(with: bounds))
                            // 非展开时，如果 GeometryReader 的 frame 比 CourseView 的尺寸大，CourseView 不会自动居中，而是在左上角开始摆放，
                            // 所以把 GeometryReader 设置成跟 CourseView 一样大：screen.width - 60，让 GeometryReader 在 VStack 中保持居中。
                            .zIndex(self.store.courses[index].show ? 1.0 : 0) // show时顶到ZStack最上面
                        }
                    }
                    .frame(width: bounds.size.width)
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
                    )
                }
                .statusBar(hidden: active)
                .animation(.linear)
                .disabled(active) // disabled：不可用 ---【应对iOS14的临时方案，日后解决】
                
                // 【应对iOS14的临时方案，日后解决】：iOS14上会优先 ScrollView 的滑动手势，会造成 CourseView 放大后 ScrollView 还能继续滑动，导致UI错乱的问题，
                // 所以这里先暂时这样解决：在上面叠加一个同样的 CourseView 来进行开发。
                if finalActive {
                    // iOS14上 ScrollView 的滑动手势，跟 CourseView 头部的拖动滑动关闭的手势有冲突，会导致UI错乱并卡死的问题
                    // 这两个手势会一起触发，导致页面上下抖来抖去，然后卡死。
                    // 目前还不知道该如何解决，故暂且使用以下2中方案来继续探讨SwiftUI。
                    
                    // 1.头部可以拖动滑动关闭，但是不能拖动查看下面内容
                    //【注意】：该方式在 iOS 15 上拖动返回时会直接卡死页面！
                    CourseView(course: $store.courses[activeIndex],
                               active: $active,
                               finalActive: $finalActive,
                               index: activeIndex,
                               activeIndex: $activeIndex,
                               activeView: $activeView,
                               bounds: bounds,
                               isDetail: true)
                        // 状态栏隐藏后整体视图会有点上移（状态栏高度大概为20），这里手动挪回来
//                        .offset(y: 20)
                        // 像这种通过条件“突然”显示的View，默认都会带有Fade效果的过渡动画
                        .transition(.identity) // 移除过渡动画
                    
                    // 2.可以拖动查看下面内容，但头部不可以拖动滑动关闭。
//                    CourseDetail(course: $store.courses[activeIndex],
//                                 activeView: $activeView,
//                                 bounds: bounds,
//                                 closeAction: {
//                        self.store.courses[activeIndex].show = false
//                        self.active = false
//                        self.finalActive = false
//                        self.activeIndex = -1
//                        self.activeView = .zero
//                    }, onChangedAction: { value in
//                        print("Dragging detail, \(value.translation.height)")
//                        guard value.translation.height > 50,
//                              value.translation.height < 300 else { return }
//                        self.activeView = value.translation
//                    }, onEndedAction: { value in
//                        if self.activeView.height > 50 {
//                            self.store.courses[activeIndex].show = false
//                            self.active = false
//                            self.finalActive = false
//                            self.activeIndex = -1
//                        }
//                        self.activeView = .zero
//                    })
//                        // 像这种通过条件“突然”显示的View，默认都会带有Fade效果的过渡动画
//                        .transition(.identity) // 移除过渡动画
                }
            }
        }
    }
}

struct CourseList_Previews: PreviewProvider {
    static var previews: some View {
        CourseList()
    }
}

// MARK: - CourseView
struct CourseView: View {
    @Binding var course: Course
    var show: Bool { course.show }
    
    @Binding var active: Bool
    @Binding var finalActive: Bool
    
    var index: Int
    @Binding var activeIndex: Int
    
    @Binding var activeView: CGSize
    
    var bounds: GeometryProxy
    
    var isDetail = false
    
    var body: some View {
        // ZStack的对齐取决于里面的子View最大的那一个
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 30.0) {
                Text("Take your SwiftUI app to the App Store with advanced techniques like API data, packages and CMS.")
                Text("About this course (\(isDetail ? "Detail" : "List"))")
                    .font(.title)
                    .bold()
                Text("This course is unlike any other. We care about design and want to make sure that you get better at it in the process. It was written for designers and developers who are passionate about collaborating and building real apps for iOS and macOS. While it's not one codebase for all apps, you learn once and can apply the techniques and controls to all platforms with incredible quality, consistency and performance. It's beginner-friendly, but it's also packed with design tricks and efficient workflows for building great user interfaces and interactions.")
                Text("Minimal coding experience required, such as in HTML and CSS. Please note that Xcode 11 and Catalina are essential. Once you get everything installed, it'll get a lot friendlier! I added a bunch of troubleshoots at the end of this page to help you navigate the issues you might encounter.")
            }
//            .animation(nil) // 保证这以上的（文字部分）没有动画 ---【会直接固定到最终位置，效果不好，还是不去掉了】
            .padding(30)
            .frame(maxWidth: .infinity,
                   maxHeight: show ? .infinity : 280,
                   alignment: .top) // 要先确定了frame，下面的background才会保持跟frame一样的大小，否则就跟VStack的内容一样的大小
            .offset(y: show ? 460 : 0) // 在这里的偏移只会对VStack的内容进行偏移，不会对下面的background偏移
            .background(Color("background1"))
            .clipShape(RoundedRectangle(cornerRadius: show ? getCardCornerRadius(with: bounds) : 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
//            .frame(maxWidth: show ? .infinity : (screen.width - 60),
//                   maxHeight: show ? .infinity : 280,
//                   alignment: .top) //【注意1】如果在background之后才设置frame，那么background的大小只会保持着跟VStack的内容一样的大小，例如frame为全屏，而VStack的内容最大只有半屏，那么background也只有半屏
//            .offset(y: show ? 460 : 0) //【注意2】如果在background之后才进行偏移，那么也会对background进行偏移
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(course.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text(course.subtitle)
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    VStack {
                        ZStack {
                            // logo
                            Image(uiImage: course.logo)
                                .opacity(show ? 0 : 1)
                            
                            // 关闭icon
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                                .opacity(show ? 1 : 0)
                                .onTapGesture {
                                    self.course.show = false
                                    self.active = false
                                    self.finalActive = false
                                    self.activeIndex = -1
                                    self.activeView = .zero
                                }
                        }
                        
                        Text(String(format: "%.2lf", self.activeView.height))
                            .foregroundColor(Color.white.opacity(0.85))
                    }
                }
                Spacer()
                WebImage(url: course.image)
                    .placeholder(
                        Image("Card4")
                            .resizable()
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 140, alignment: .top)
            }
            .padding(show ? 30 : 20)
            .padding(.top, show ? 30 : 0)
            .frame(maxWidth: .infinity)
            .frame(height: show ? 460 : 280)
            .background(Color(course.color))
            .clipShape(RoundedRectangle(cornerRadius: show ? getCardCornerRadius(with: bounds) : 30, style: .continuous))
            .shadow(color: Color(course.color).opacity(0.3), radius: 20, x: 0, y: 20)
            .gesture(
                show ?
                DragGesture()
                    .onChanged { value in
                        print("Dragging list, \(value.translation.height)")
                        guard value.translation.height > 0,
                              value.translation.height < 300 else { return }
                        self.activeView = value.translation
                    }
                    .onEnded { value in
                        if self.activeView.height > 50 {
                            self.course.show = false
                            self.active = false
                            self.finalActive = false
                            self.activeIndex = -1
                        }
                        self.activeView = .zero
                    }
                : nil
            )
            .onTapGesture {
                guard !self.active else { return }
                self.course.show = true
                self.active = true
                self.activeIndex = self.index
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard self.finalActive != self.active else { return }
                    self.finalActive = self.active
                }
            }
        }
        // CourseView show为true时高度为屏幕高度，而 GeometryReader 的 bounds.size 是没有包括安全距离的，得手动加上这个安全距离。
        .frame(height: show ? (bounds.size.height + bounds.safeAreaInsets.top + bounds.safeAreaInsets.bottom) : 280)
        .scaleEffect(show ? (1 - activeView.height / 1000) : 1)
        .rotation3DEffect(
            Angle(degrees: show ? Double(activeView.height / 10) : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .hueRotation(Angle(degrees: show ? Double(activeView.height) : 0))
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        .edgesIgnoringSafeArea(.all)
    }
}
