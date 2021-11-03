//
//  LoginView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/8/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    /// 如果使用`isFocused`，那么只要`isFocused`设置为 false 后键盘收缩的动画就立马消失了，所以为了确保这个动画能执行完，使用`isTrueFocused`来进行判断（`isFocused`为 false 时延迟 0.1 后`isTrueFocused`才为 false）
    @State var isTrueFocused = false
    @State var isFocused = false {
        didSet {
            if isFocused {
                isTrueFocused = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTrueFocused = isFocused
                }
            }
        }
    }
    @State var showAlear = false
    @State var alertMessage = "Something went wrong."
    @State var isLoading = false
    @State var isSuccess = false
    @EnvironmentObject var user: UserStore
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .top) {
                Color("background2")
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .edgesIgnoringSafeArea(.bottom)
                
                CoverView()
                
                VStack {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                        
                        TextField("My Email".uppercased(), text: $email)
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
                            // 即便 TextField 修改了frame，但可点击范围（弹起键盘）还是自身的大小区域
                            // 添加背景色可查看具体范围
//                            .background(Color.yellow)
                            .padding(.leading)
                            .frame(height: 44)
//                            .background(Color.red)
                            .onTapGesture {
                                isFocused = true
                            }
                    }
                    
                    Divider()
                        .padding(.leading, 80)

                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                        
                        SecureField("My Password".uppercased(), text: $password)
                            .keyboardType(.default)
                            .font(.subheadline)
                            // 即便 TextField 修改了frame，但可点击范围（弹起键盘）还是自身的大小区域
                            // 添加背景色可查看具体范围
//                            .background(Color.yellow)
                            .padding(.leading)
                            .frame(height: 44)
//                            .background(Color.red)
                            .onTapGesture {
                                isFocused = true
                            }
                    }
                }
                .frame(height: 136)
                // 这里的maxWidth不使用infinity了，712是iPad端的弹窗视图建议的最大宽度
                .frame(maxWidth: 712)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                .padding(.horizontal)
                .offset(y: 460)
                
                HStack {
                    Button(action: {}) {
                        Text("Forgot password?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        login()
                    }) {
                        Text("Log in")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                    .alert(isPresented: $showAlear) {
                        Alert(title: Text("Error"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
            }
            .offset(y: isFocused ? -300 : 0)
            // 如果使用isFocused，那么只要isFocused设置为false后这个跟随键盘收缩的动画就立马消失了，所以为了确保这个动画能执行完，使用isTrueFocused来进行判断（isFocused为false时延迟0.1后isTrueFocused才为false）
            .animation(isTrueFocused ? .easeInOut : nil)
            .onTapGesture {
                isFocused = false
                hideKeyboard()
            }
            
            if isLoading {
                LoadingView()
            }
            
            if isSuccess {
                SuccessView()
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func login() {
        isFocused = false
        hideKeyboard()
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            print(Thread.current)
            isLoading = false
            
            if let error = error {
                alertMessage = error.localizedDescription
                showAlear = true
                return
            }
            
            isSuccess = true
            user.isLogged = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isSuccess = false
                email = ""
                password = ""
                user.showLogin = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: - CoverView
struct CoverView: View {
    @State var show = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                // 这里的 geometry 给到的信息是 GeometryReader 经过下面所有 Modifier 修改后的布局信息。
                // 例如设置了最大宽度375，水平左右边距各为16，那么  geometry.size.width = 375 - 16 * 2 = 343
                Text("Learn design & code.\nFrom scratch.")
                    .font(.system(size: geometry.size.width / 10, weight: .bold))
                    .foregroundColor(.white)
            }
            // 修改布局
            .frame(maxWidth: 375, maxHeight: 100)
            .padding(.horizontal, 16)
            .offset(x: viewState.width / 15, y: viewState.height / 15)
            
            Text("80 hours of courses for SwiftUI,\nReact and design tools.")
                .font(.subheadline)
                .frame(width: 250)
                .offset(x: viewState.width / 20, y: viewState.height / 20)
            
            Spacer()
            
            // 测试的
//            Text("viewState: \(Int(viewState.width)), \(Int(viewState.height))")
//                .font(.subheadline)
//                .foregroundColor(.red)
//                .background(Color.black)
        }
        .multilineTextAlignment(.center) // 在父容器设置对齐方式或其他通用的Modifier，能直接应用于里面所有的子容器
        .padding(.top, 100)
        .frame(height: 477)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(uiImage: #imageLiteral(resourceName: "Blob"))
                    .offset(x: -150, y: -200)
                    .rotationEffect(Angle(degrees: show ? (360 + 90) : 90))
                    .blendMode(.plusDarker)
                    .animation(Animation.linear(duration: 120).repeatForever(autoreverses: false))
                
                Image(uiImage: #imageLiteral(resourceName: "Blob"))
                    .offset(x: -200, y: -250)
                    .rotationEffect(Angle(degrees: show ? 360 : 0), anchor: .leading)
                    .blendMode(.overlay)
                    .animation(Animation.linear(duration: 100).repeatForever(autoreverses: false))
            }
//            .animation(Animation.linear(duration: 120).repeatForever(autoreverses: false))
            .onAppear {
                show.toggle()
            }
        )
        .background(
            Image(uiImage: #imageLiteral(resourceName: "Card3"))
                .offset(x: viewState.width / 25, y: viewState.height / 25),
            alignment: .bottom
        )
        .background(Color(#colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 0.9725490196, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .scaleEffect(isDragging ? 0.9 : 1)
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
        .rotation3DEffect(
            Angle(degrees: 5),
            axis: (x: viewState.width, y: viewState.height, z: 0.0)
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewState = value.translation
                    isDragging = true
                }
                .onEnded { value in
                    viewState = .zero
                    isDragging = false
                }
        )
    }
}
