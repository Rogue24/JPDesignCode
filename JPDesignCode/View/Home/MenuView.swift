//
//  MenuView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/13.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var user: UserStore
    @Binding var showProfile: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("ZJP - 35% complete")
                    .font(.caption)
                
                Color.white
                    .frame(width: 130.0 * (35.0 / 100.0))
                    .cornerRadius(3)
                    // 1.此时再次设置frame则不会影响到上一个widget（一开始的Color）了
                    .frame(width: 130.0, height: 6, alignment: .leading)
                    // 放入背景widget，背景widget的frame是上面新设置的frame
                    .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.08))
                    // 此后的设置也是对上一个widget的设置
                    .cornerRadius(3)
                    .padding()
                    // 2.再设置新的frame，同样不会影响到上一个widget，而是对于后续的widget
                    .frame(width: 150, height: 24)
                    .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1))
                    .cornerRadius(12)
                
                MenuRow(icon: "gear", title: "Account")
                MenuRow(icon: "creditcard", title: "Billing")
                MenuRow(icon: "person.crop.circle", title: "Sign out")
                    .onTapGesture {
                        user.isLogged = false
                        showProfile = false
                    }
            }
            .frame(maxWidth: 500) // 这里不使用infinity了，最大500以适配iPad端
            .frame(height: 300) // `固定宽高`不能跟`最大最小宽高`一起设置
//            .background(LinearGradient(gradient: Gradient(colors: [Color("background3"), Color("background3").opacity(0.6)]), startPoint: .top, endPoint: .bottom))
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            // 一个类型连续调用多次函数，类型名（Color）要加上。
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            // overlay：叠加层，可以在里面添加额外的view覆盖到父view上面（上面已经用clipShape裁剪了，所以在这里才添加就不会被裁剪掉）
            .overlay(
                Image("Avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .offset(y: -150)
            )
        }
        .padding(.bottom, 30)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showProfile: .constant(true))
            .environmentObject(UserStore())
    }
}

// MARK: - MenuRow
struct MenuRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .light))
                .imageScale(.large)
                .frame(width: 32, height: 32)
                .foregroundColor(Color(#colorLiteral(red: 0.662745098, green: 0.7333333333, blue: 0.831372549, alpha: 1)))
            
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .frame(width: 120, alignment: .leading)
        }
    }
}
