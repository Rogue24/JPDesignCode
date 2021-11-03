//
//  CourseDetail.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/7/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CourseDetail: View {
    @Binding var course: Course
    @Binding var activeView: CGSize
    var bounds: GeometryProxy
    
    var closeAction: () -> Void
    var onChangedAction: (DragGesture.Value) -> Void
    var onEndedAction: (DragGesture.Value) -> Void
    
    @State var showXmark = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
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
                        
                        // 关闭icon
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 36, height: 36)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                            .offset(x: -2, y: 2) // 不知道为啥位置会有些许偏差，这里修补一下
//                            .opacity(showXmark ? 1 : 0)
//                            .scaleEffect(showXmark ? 1 : 0.2)
//                            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
//                            .onAppear {
//                                self.showXmark = true
//                            }
                            .onTapGesture(perform: closeAction)
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
                .padding(30)
                .padding(.top, 30)
                .frame(maxWidth: .infinity)
                .frame(height: 460)
                .background(Color(course.color))
                .clipShape(RoundedRectangle(cornerRadius: getCardCornerRadius(with: bounds), style: .continuous))
                .shadow(color: Color(course.color).opacity(0.3), radius: 20, x: 0, y: 20)
                // iOS14上 ScrollView 的滑动手势，跟子视图的头部的拖动滑动关闭的手势有冲突，会导致UI错乱并卡死的问题
                // 这两个手势会一起触发，导致页面上下抖来抖去，然后卡死。
                // 目前还不知道该如何解决，故暂且不添加该手势。
//                .gesture(
//                    DragGesture()
//                        .onChanged(onChangedAction)
//                        .onEnded(onEndedAction)
//                )
                
                VStack(alignment: .leading, spacing: 30.0) {
                    Text("Take your SwiftUI app to the App Store with advanced techniques like API data, packages and CMS.")
                    Text("About this course (Detail)")
                        .font(.title)
                        .bold()
                    Text("This course is unlike any other. We care about design and want to make sure that you get better at it in the process. It was written for designers and developers who are passionate about collaborating and building real apps for iOS and macOS. While it's not one codebase for all apps, you learn once and can apply the techniques and controls to all platforms with incredible quality, consistency and performance. It's beginner-friendly, but it's also packed with design tricks and efficient workflows for building great user interfaces and interactions.")
                    Text("Minimal coding experience required, such as in HTML and CSS. Please note that Xcode 11 and Catalina are essential. Once you get everything installed, it'll get a lot friendlier! I added a bunch of troubleshoots at the end of this page to help you navigate the issues you might encounter.")
                }
                .padding(30)
            }
        }
        // 这里的maxWidth不使用infinity了，712是iPad端的弹窗视图建议的最大宽度
        .frame(maxWidth: 712)
        .background(Color("background1"))
        .clipShape(RoundedRectangle(cornerRadius: getCardCornerRadius(with: bounds), style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        .edgesIgnoringSafeArea(.all)
        // 如果在.edgesIgnoringSafeArea(.all)之后再设置背景和圆角，顶部会被裁掉刘海的高度，底部会被裁掉下巴的高度，但背景没被裁，不知道为啥~
        .scaleEffect(1 - activeView.height / 1000)
        .rotation3DEffect(
            Angle(degrees: Double(activeView.height / 10)),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .hueRotation(Angle(degrees: Double(activeView.height)))
    }
}

struct CourseDetail_Previews: PreviewProvider {
    static var previews: some View {
        var course: Course = courseData[0]
        course.show = true
        return GeometryReader { bounds in
            CourseDetail(course: .constant(course), activeView: .constant(.zero), bounds: bounds, closeAction: {}, onChangedAction: { _ in }, onEndedAction: { _ in })
        }
    }
}
