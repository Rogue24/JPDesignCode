//
//  RingView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/30.
//

import SwiftUI

struct RingView: View {
    var color1 = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    var color2 = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    var width: CGFloat = 88
    var height: CGFloat = 88
    var percent: CGFloat = 66
    var ringAnim: Animation? = .none
    
    @Binding var show: Bool
    
    var body: some View {
        let multiplier = width / 44
        let progress = 1 - percent / 100
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1),
                        style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)
            
            Circle()
                .trim(from: show ? progress : 1, to: 1) // 初始值，最终值（0~1）
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(color1), Color(color2)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 5 * multiplier,
                                       lineCap: .round,
                                       lineJoin: .round,
                                       miterLimit: .infinity,
                                       dash: [20, 0], // 第一个是虚线每一块的长度，第二个是虚线块之间的最大间距
                                       dashPhase: 0))
                //【圆环动画】要在这里加才行，声明这个动画仅限于此，也就是圆环部分，不影响后面的Modifiers（如果在外部加会影响整个RingView，包括frame）
                .animation(ringAnim) // Animation.easeInOut.delay(0.3)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(
                    Angle(degrees: 180), axis: (x: 1.0, y: 0, z: 0.0)
                )
                .frame(width: width, height: height)
                .shadow(color: Color(color2).opacity(0.1), radius: 3 * multiplier, x: 0, y: 3 * multiplier)
                
            Text(String(format: "%.0lf%%", percent))
                .font(.system(size: 14 * multiplier))
                .fontWeight(.bold)
//                .onTapGesture {
//                    self.show.toggle()
//                }
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(show: .constant(true))
    }
}
