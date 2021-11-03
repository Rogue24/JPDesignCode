//
//  ContentView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/6.
//

import SwiftUI

struct ContentView: View {
    
    /// 参考：https://blog.csdn.net/studying_ios/article/details/103294890
    /// 如果想在struct的方法中修改属性值，需要在方法前面添加mutating关键字，比如这样：
    /// mutating func abc() { }
    /// 但是Swift不允许声明可修改的计算属性：mutating var body: some View { }  ---  会报错
    /// 使用【@State】修饰，可以动态修改属性值，包括计算属性内，超出struct本身的限制。
    
    @State var show = false
    @State var viewState = CGSize.zero
    @State var showCard = false
    @State var bottomState = CGSize.zero
    @State var showFull = false
    
    // body 是计算属性，想在里面修改属性但不能用mutating修饰，那就得使用@State修饰的属性
    // @State修饰的属性可以动态修改属性值，包括计算属性内
    var body: some View {
        ZStack {
            TitleView()
                .blur(radius: show ? 20 : 0)
                .opacity(showCard ? 0.4 : 1)
                .offset(y: showCard ? -200 : 0)
                .animation(
                    // Animation.default 返回 Animation对象，因此可以接着后面继续调用.delay(0.1)，
                    // 一个类型如果只调用一次函数，类型名（Animation）可以不加，系统能类型推到，
                    // 不过如果直接这样写 .default.delay(0.1)，系统无法推断正确类型，
                    // 所以一个类型连续调用多次函数，类型名（Animation）要加上。
                    Animation
                        .default
                        .delay(0.1)
                )
            
            BackCardView(bgColor: show ? Color("card4") : Color("card3"), width: showCard ? 300 : 340)
                .offset(y: show ? -400 : -40)
                .offset(x: viewState.width, y: viewState.height)
                .offset(y: showCard ? -180 : 0)
                .scaleEffect(showCard ? 1 : 0.9)
                .rotationEffect(.degrees(show ? 0 : 10))
                .rotationEffect(.degrees(showCard ? -10 : 0)) // 用于抵消上面的10°
                .rotation3DEffect(
                    .degrees(showCard ? 0 : 10),
                    axis: (x: 1, y: 0.0, z: 0.0)
                )
                .blendMode(.hardLight)
                .animation(.spring())
            
            BackCardView(bgColor: show ? Color("card3") : Color("card4"), width: 340)
                .offset(y: show ? -200 : -20)
                .offset(x: viewState.width, y: viewState.height)
                .offset(y: showCard ? -140 : 0)
                .scaleEffect(showCard ? 1 : 0.95)
                .rotationEffect(.degrees(show ? 0 : 5))
                .rotationEffect(.degrees(showCard ? -5 : 0)) // 用于抵消上面的5°
                .rotation3DEffect(
                    .degrees(showCard ? 0 : 5),
                    axis: (x: 1, y: 0.0, z: 0.0)
                )
                .blendMode(.hardLight)
                .animation(.spring())
            
            CardView()
                .frame(maxWidth: showCard ? 375 : 340.0)
                .frame(height: 220.0)
                .background(Color.black)
//                .cornerRadius(20)
                .clipShape(RoundedRectangle(cornerRadius: showCard ? 30 : 20, style: .continuous))
                .shadow(radius: 20)
                .offset(x: viewState.width, y: viewState.height)
                .offset(y: showCard ? -100 : 0)
                .blendMode(.hardLight)
                // response：响应时间，例如该值越小，手势拖动时滞后时间越短
                // dampingFraction：阻力，越小弹性越明显
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
                .onTapGesture {
                    self.showCard.toggle()
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.viewState = value.translation
                            self.show = true
                        }
                        .onEnded { _ in
                            self.viewState = .zero
                            self.show = false
                        }
                )
            
//            Text("\(bottomState.height)").offset(y: -300)
            
            GeometryReader { bounds in
                BottomCardView(show: $showCard)
                    .offset(y: showCard ?
                                (bounds.size.height * 0.5) :
                                // BottomCardView 默认放在屏幕底部以外的地方，
                                // 而 GeometryReader 的 bounds.size 是没有包括安全距离的，
                                // 如果这里不使用.edgesIgnoringSafeArea(.all)，则这里的高度得手动加上这个安全距离
                                (bounds.size.height + bounds.safeAreaInsets.top + bounds.safeAreaInsets.bottom))
                    .offset(y: bottomState.height)
                    .blur(radius: show ? 20 : 0)
                    .opacity(show ? 0 : 1)
                    .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.bottomState = value.translation
                                if self.showFull {
                                    self.bottomState.height += -300
                                }
                                if self.bottomState.height < -300 {
                                    self.bottomState.height = -300
                                }
                            }
                            .onEnded { value in
                                // 1.没有铺满：超过基准线（offsetY = 360）以上100点，挪到铺满线
                                // 2.已经铺满：不超过铺满线（offsetY = 360 - 300）以下100点，回到铺满线
                                if (!self.showFull && self.bottomState.height < -100) ||
                                    (self.showFull && self.bottomState.height < -200) {
                                    // 铺满：基准线（offsetY = 360）以上300点为铺满线
                                    self.bottomState.height = -300
                                    self.showFull = true
                                    return
                                }
                                
                                // 只要超过基准线（offsetY = 360）以下50点，收起
                                if self.bottomState.height > 50 {
                                    self.showCard = false
                                }
                                
                                // 重置非铺满：如果没收起，回到基准线（offsetY = 360）
                                self.bottomState = .zero
                                self.showFull = false
                            }
                    )
            }
            // 忽略安全区域交给要使用ContentView的视图（外部）来设置
            // .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 320, height: 667)) // 自定义预览大小
    }
}

// MARK: - CardView
struct CardView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello, ZJP!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("You are the best.")
                        .foregroundColor(Color("accent"))
                }
                Spacer() // 以此为分界，将前后元素分别推开至边上（如HStack则在水平方向推开）
                Image("Logo1")
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Spacer()
            Image("Card1")
                .resizable()
                .aspectRatio(contentMode: .fill) // 按图片宽高比填充
                .frame(width: 300.0, height: 110.0, alignment: .top)
            /// 图片默认以原尺寸展示
            /// - 例如图片200*200，则逻辑尺寸也为200*200
            /// resizable：让图片自适应
            /// - 当图片自己或父组件设置了固定宽高，如果图片原尺寸会超出范围，设置resizable可以让图片适应这个宽高值（伸缩至这个范围内），优先自适应图片自己宽高
            /// frame(width: 300.0, height: 110.0, alignment: .top)
            /// - 设置固定宽高，如果图片（按宽高比填充后）仍超出该范围，则从顶部开始展示（默认中心展示）
        }
    }
}

// MARK: - BackCardView
struct BackCardView: View {
    let bgColor: Color
    let width: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(maxWidth: width) // 宽度使用最大值（最大不会超过最大值），是为了动态适应小屏
        .frame(height: 220.0) // 高度则使用固定值
        .background(bgColor)
        // 1.如果先设置shadow再设置cornerRadius，那么阴影会被裁剪掉
//        .shadow(radius: 20)
        .cornerRadius(20)
        // 2.所以要先设置cornerRadius再设置shadow，先裁剪了再添加阴影
        .shadow(radius: 20)
        ///【一定要注意设置顺序！！！】
        /// - 如果先设置shadow再设置cornerRadius，那么阴影会被裁剪掉
        /// - 所以要先设置cornerRadius再设置shadow，先裁剪了再添加阴影
    }
}

// MARK: - TitleView
struct TitleView: View {
    var body: some View {
        VStack {
            HStack {
                Text("JP-SwiftUI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            Image("Background1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 375)
            Spacer()
        }
    }
}

// MARK: - BottomCardView
struct BottomCardView: View {
    @Binding var show: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(2.5)
                .opacity(0.1)
            Text("这是我的SwiftUI学习Demo，尽量保持每天学习2小时吧！加油亲！我还有梦想！要努力！不能颓废！冲啊！！！！！！！！！")
                .multilineTextAlignment( .center)
                .font(.subheadline)
                .lineSpacing(4)
            
            HStack(spacing: 20.0) {
                RingView(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.6956463456, green: 0.507235229, blue: 0.9192920923, alpha: 1), width: 88, height: 88, percent: 88, ringAnim: Animation.easeInOut.delay(0.3), show: $show)
                //【圆环动画】不能在这里设置，会影响整个RingView，包括frame，要在Circle().trim(...).stroke(...).anxxx 后面这里加动画
                // .animation(Animation.easeInOut.delay(0.3))
                
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("SwiftUI")
                        .fontWeight(.bold)
                    Text("12 of 12 sections completed\n10 hours spent so far.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(Color("background3"))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(maxWidth: 712) // 这里的maxWidth不使用infinity了，712是iPad端的弹窗视图建议的最大宽度
        .background(BlurView(style: .systemThinMaterial))
        .cornerRadius(30)
        .shadow(radius: 20)
        // 至此，以上所有内容的尺寸是已经固定好了的，接下来设置的frame是不会影响到上面内容的
        .frame(maxWidth: .infinity) // 宽度最大至父视图的宽度（如果父视图的宽度超出上面设置的最大宽度，那么上面内容则会以【居中】显示）
    }
}
