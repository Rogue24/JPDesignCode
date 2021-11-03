//
//  HomeView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/14.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showProfile: Bool
    @State var showUpdate = false
    @Binding var showContent: Bool
    var topSafeAreaInset: Double
    
    @ObservedObject var store = CourseStore()
    @State var active = false
    @State var finalActive = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Hello, World!")
//                                .font(.system(size: 12, weight: .bold))
                                // 字体优先于Modifier
                                // 只要使用“.font”或“设置字体的Modifier”设置了字体，接着后面的Modifier再怎么设置字体都无效 --- 只会认定第一次设置的字体。
                                .modifier(CustomFontModifier(size: 28))
//                                .font(.system(size: 12, weight: .bold)) // 再次设置，已经无效了

                            Spacer()
                            
                            // 用于查看Dismiss后这个showUpdate是否自动置false
//                            Text("showUpdate \(showUpdate ? "true" : "false")")
//                                .font(.system(size: 12))

                            AvatarView(showProfile: $showProfile)
                            
                            Button(action: {
                                self.showUpdate.toggle()
                            }) {
                                Image(systemName: "bell")
//                                    .renderingMode(.original)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 36, height: 36)
                                    .background(Color("background3"))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            }
                            // 当Dismiss后会自动将这个绑定值置非：showUpdate.toggle()
                            .sheet(isPresented: $showUpdate) {
                                UpdateList()
                            }
                        }
                        .padding(.horizontal) // 默认间距为16
                        .padding(.leading, 14) // 在左边再添加14，使其为30，跟ScrollView内容对齐
                        .padding(.top, 30 + topSafeAreaInset)
                        .blur(radius: active ? 20 : 0)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            WatchRingsView()
                                .padding(.horizontal, 30)
                                .padding(.bottom, 30) // 为了不遮挡阴影增加底部间距
                                .onTapGesture {
                                    self.showContent = true
                                }
                        }
                        .blur(radius: active ? 20 : 0)
                        
                        // ScrollView的滚动取决于子widget
                        // 例如，如果设置horizontal，但里面用的是VStack，则不能上下滑动，只能一整列widget左右滑动
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(sectionData) { section in
                                    // GeometryReader：当几何信息发生变化就会通过geometry返回
                                    // 只要有变化就触发：例如此处的ScrollView滚动时，会不断触发{ g in ... }
                                    GeometryReader { geometry in
                                        // geometry.frame(in: .global)：当前这个GeometryReader的frame（相对于屏幕）信息
                                        SectionView(section: section,
                                                    message: "\(String(format: "%.2lf", geometry.frame(in: .global).minX))")
                                            .rotation3DEffect(
                                                .degrees(
                                                    // 减去30是为了跟padding一致，抵消间距，使其左边对齐
                                                    // 除以-20（iPad端为-80）是为了降低旋转幅度
                                                    Double(geometry.frame(in: .global).minX - 30) / -getAngleMultiplier(with: bounds)
                                                ),
                                                axis: (x: 0.0, y: 1.0, z: 0.0)
                                            )
                                    }
                                    // 设置GeometryReader的大小：最好跟（包裹的）SectionView一样大小
                                    // 然后再通过里面的geometry提供的几何信息对SectionView（不是GeometryReader）作其他修改
                                    .frame(width: 275, height: 275)
                                }
                            }
                            .padding(30)
                            .padding(.bottom, 30)
                        }
                        .offset(y: -30) // 抵消上面为了不遮挡WatchRingsView阴影而增加的间距
                        .blur(radius: active ? 20 : 0)
                        
                        HStack {
                            Text("Courses")
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        .padding(.leading, 30)
                        .offset(y: -60)
                        .blur(radius: active ? 20 : 0)
                        
//                        SectionView(section: sectionData[2], width: bounds.size.width - 60, height: 275)
//                            .offset(y: -50)
                        // 从`CourseList`那边拷贝过来替换占位用的SectionView
                        VStack(spacing: 30) {
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
                        .padding(.bottom, bounds.size.width > 500 ? 200 : 0)
                        .offset(y: -60)
                        
                        Spacer() // 如果内容不足屏幕高，那么上面内容会均分摆放，所以加个Spacer把上面内容顶上去
                    }
                    //.frame(width: bounds.size.width) // iOS 13这里要设置宽度，不然会在TabBar切换回来时由于不确定宽度导致有形变过程
                }
                .disabled(active) // disabled：不可用 ---【应对iOS14的临时方案，日后解决】
                
                // 【应对iOS14的临时方案，日后解决】：iOS14上会优先 ScrollView 的滑动手势，会造成 CourseView 放大后 ScrollView 还能继续滑动，导致UI错乱的问题，
                // 所以这里先暂时这样解决：在上面叠加一个同样的 CourseView 来进行开发。
                if finalActive {
                    // iOS14上 ScrollView 的滑动手势，跟 CourseView 头部的拖动滑动关闭的手势有冲突，会导致UI错乱并卡死的问题
                    // 这两个手势会一起触发，导致页面上下抖来抖去，然后卡死。
                    // 目前还不知道该如何解决，故暂且使用以下2中方案来继续探讨SwiftUI。
                    
                    // 1.头部可以拖动滑动关闭，但是不能拖动查看下面内容
                    //【注意】：该方式在 iOS 15 上拖动返回时会直接卡死页面！
//                    CourseView(course: $store.courses[activeIndex],
//                               active: $active,
//                               finalActive: $finalActive,
//                               index: activeIndex,
//                               activeIndex: $activeIndex,
//                               activeView: $activeView,
//                               bounds: bounds,
//                               isDetail: true)
//                        // 像这种通过条件“突然”显示的View，默认都会带有Fade效果的过渡动画
//                        .transition(.identity) // 移除过渡动画
                    
                    // 2.可以拖动查看下面内容，但头部不可以拖动滑动关闭。
                    CourseDetail(course: $store.courses[activeIndex],
                                 activeView: $activeView,
                                 bounds: bounds,
                                 closeAction: {
                        self.store.courses[activeIndex].show = false
                        self.active = false
                        self.finalActive = false
                        self.activeIndex = -1
                        self.activeView = .zero
                    }, onChangedAction: { value in
                        print("Dragging detail, \(value.translation.height)")
                        guard value.translation.height > 50,
                              value.translation.height < 300 else { return }
                        self.activeView = value.translation
                    }, onEndedAction: { value in
                        if self.activeView.height > 50 {
                            self.store.courses[activeIndex].show = false
                            self.active = false
                            self.finalActive = false
                            self.activeIndex = -1
                        }
                        self.activeView = .zero
                    })
                        // 像这种通过条件“突然”显示的View，默认都会带有Fade效果的过渡动画
                        .transition(.identity) // 移除过渡动画
                }
            }
        }
    }
    
    func getAngleMultiplier(with bounds: GeometryProxy) -> Double {
        if bounds.size.width > 500 {
            return 80
        } else {
            return 20
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showProfile: .constant(false), showContent: .constant(false), topSafeAreaInset: 0)
    }
}

// MARK: - SectionView
struct SectionView: View {
    var section: Section
    var message: String = ""
    var width: CGFloat = 275
    var height: CGFloat = 275
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 160, alignment: .leading)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(section.logo)
            }
            
            HStack {
                Text(section.text.uppercased())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(message)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: width, height: height)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.color.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

// MARK: - WatchRingsView
struct WatchRingsView: View {
    var body: some View {
        HStack(spacing: 30) {
            HStack(spacing: 12.0) {
                RingView(color1: #colorLiteral(red: 1, green: 0.6381785274, blue: 0.7139522433, alpha: 1), color2: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), width: 44, height: 44, percent: 64, ringAnim: .none, show: .constant(true))
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("6 minutes left").bold().modifier(FontModifier(style: .subheadline))
                    Text("Watched 10 mins today").modifier(FontModifier(style: .caption))
                }
                .modifier(FontModifier()) // 在VStack/HStack/ZStack设置字体，会自动应用到里面所有（没有设置字体）的Text
            }
            .padding(8)
            .background(Color("background3"))
            .cornerRadius(20)
            .modifier(ShadowModifier())
            
            HStack {
                RingView(color1: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), width: 32, height: 32, percent: 44, ringAnim: .none, show: .constant(true))
            }
            .padding(8)
            .background(Color("background3"))
            .cornerRadius(20)
            .modifier(ShadowModifier())
            
            HStack {
                RingView(color1: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), width: 32, height: 32, percent: 28, ringAnim: .none, show: .constant(true))
            }
            .padding(8)
            .background(Color("background3"))
            .cornerRadius(20)
            .modifier(ShadowModifier())
        }
    }
}
