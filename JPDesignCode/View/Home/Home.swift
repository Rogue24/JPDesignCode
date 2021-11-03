//
//  Home.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/14.
//

import SwiftUI

let screen = UIScreen.main.bounds

struct Home: View {
    
    @State var showProfile = false
    @State var viewState = CGSize.zero
    @State var showContent = false
    @EnvironmentObject var user: UserStore
    
    var degrees: Double {
        if showProfile {
            return -10 + Double(viewState.height / 10)
        } else {
            return 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("background2")
                    .edgesIgnoringSafeArea(.all) // 忽略安全区域（延伸至全屏）
                
                HomeBackgroundView(showProfile: $showProfile)
                    .offset(y: showProfile ? -450 : 0)
                    .rotation3DEffect(
                        Angle(degrees: degrees),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .scaleEffect(showProfile ? 0.9 : 1)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                    .edgesIgnoringSafeArea(.all)
                
                HomeView(showProfile: $showProfile, showContent: $showContent, topSafeAreaInset: geometry.safeAreaInsets.top)
                    .offset(y: showProfile ? -450 : 0)
                    .rotation3DEffect(
                        Angle(degrees: degrees),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .scaleEffect(showProfile ? 0.9 : 1)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                    .edgesIgnoringSafeArea(.all)
                
                MenuView(showProfile: $showProfile)
                    // 设置背景为了让背景也能交互（手势能响应），同时希望这个背景是透明的
                    // 如果设置为0，就无法交互（系统定义为隐藏），而设置为0.001，就能看不到，但实则存在，并且具有交互性
                    // 也就是说，完全透明（opacity <= 0）的widget或区域，是无法交互的（手势无法响应）
                    .background(Color.red.opacity(0.000000001))
                    .offset(y: showProfile ? 0 : screen.height)
                    .offset(y: viewState.height)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                    .onTapGesture {
                        self.showProfile.toggle()
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                self.viewState = value.translation
                            }
                            .onEnded { value in
                                if self.viewState.height > 50 {
                                    self.showProfile = false
                                }
                                self.viewState = .zero
                            }
                    )
                
                if user.showLogin {
                    LoginView()
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark")
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding()
                    .onTapGesture {
                        user.showLogin = false
                    }
                }
                
                if showContent {
                    BlurView(style: .systemMaterial)
                        .edgesIgnoringSafeArea(.all)
                    
                    ContentView()
                    
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark")
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .offset(x: -16, y: 16)
                    .transition(.move(edge: .top))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0))
                    .onTapGesture {
                        self.showContent = false
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.colorScheme, .dark) // 设置深色模式
//            .environment(\.sizeCategory, .extraExtraLarge) // 设置大字号模式（UIScreen.scale）
            .environmentObject(UserStore()) // 预览模式得在这设置环境对象，不过这个环境对象的作用范围也仅此文件内，而且如果不在这里配置的话，预览模式时修改该环境对象会报错；App入口则在WindowGroup中的祖先视图设置，这才是全局通用，得用模拟器或真机运行
    }
}

// MARK: - AvatarView
struct AvatarView: View {
    
    // @Binding 绑定一个外部的@State属性，或另一个已经绑定过的@Binding属性
    // 不能设置默认值，因为是动态的且多个widget之间【共享】的
    // 用处：在这里改变这个绑定值，则外部的状态值也会跟着改变，同理外部改变这里也会跟着改变
    @Binding var showProfile: Bool
    
    @EnvironmentObject var user: UserStore
    
    var body: some View {
        if user.isLogged {
            Button(action: {
                self.showProfile.toggle()
            }) {
                Image("Avatar")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
        } else {
            Button(action: {
                user.showLogin.toggle()
            }) {
                Image(systemName: "person")
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(Color("background3"))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            }
        }
    }
}

// MARK: - HomeBackgroundView
struct HomeBackgroundView: View {
    @Binding var showProfile: Bool
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [Color("background2"), Color("background1")]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
            Spacer()
        }
        .background(Color("background1"))
        .clipShape(RoundedRectangle(cornerRadius: showProfile ? 30 : 0, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
    }
}
