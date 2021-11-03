//
//  TestView.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/7/2.
//

import SwiftUI

struct RedBackgroundAndCornerView<Content: View>: View {
    let content: Content
    @State var needHidden: Bool = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.red)
            .cornerRadius(5)
    }
}

struct TestView: View {
    @State var isA = true
    @State(initialValue: "123") var testStr
    
//    var body: some View {
////        ScrollView {
//            VStack {
//                HStack(alignment: .top) {
//                    VStack(alignment: .leading, spacing: 8.0) {
//                        Text("123")
//                            .font(.system(size: 24, weight: .bold))
//                            .foregroundColor(.white)
//                            .background(Color.green)
//                        Text("dssss")
//                            .foregroundColor(Color.white.opacity(0.7))
//                    }
//
//        //            Spacer(minLength: 0) // 默认都会有一些间距的，当内容很长不想有间距就得手动设置为0
//
//                    Image(uiImage: #imageLiteral(resourceName: "Logo1")) // 这种好像有一定间距？
//
//        //            Image(systemName: "xmark")
//        //                .font(.system(size: 16, weight: .medium))
//        //                .frame(width: 36, height: 36)
//        //                .foregroundColor(.white)
//        //                .background(Color.black)
//        //                .clipShape(Circle())
//                }
//                .padding(30)
//                .padding(.top, 30)
//                .frame(maxWidth: .infinity,
//                       maxHeight: 460)
//                .background(Color.yellow)
//
//
//            }
////        }
//    }
    
    // @ViewBuilder：允许闭包中提供多个View
    var body: some View {
        // View的body就是使用@ViewBuilder修饰的：@ViewBuilder var body: Self.Body { get }
        // 所以可以直接在这里面使用if或者switch选择性返回哪个View
        if isA {
            ZStack {
                Color.yellow
                Text(testStr)
                    .onTapGesture {
                        testStr = "456"
                        isA = false
                    }
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Text("\(String(format: "%.2lf", geometry.frame(in: .global).maxY))")
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .edgesIgnoringSafeArea(.all)
        } else {
            Text(testStr)
                .padding()
                .background(Color.green) // 如果在padding前面加背景色，那么这个背景色则是添加padding前的大小
                .onTapGesture {
                    testStr = "123"
                    isA = true
                }
        }
        
//        RedBackgroundAndCornerView {
//            // 使用@ViewBuilder，就可以使用if或者switch选择性返回哪个View
//            // 如果不使用@ViewBuilder修饰，那么闭包里面只能返回一个View，这里就会报错
//            if isA {
//                Text("123")
//                    .padding()
//            } else {
//                Text("456")
//                    .padding()
//            }
//
//            // 如果像这样直接这样一个个View排着返回，只会显示第一个
////            Color.green
////                .frame(width: 30, height: 30)
////            Text("2")
////                .padding()
////            Text("456999999999")
////                .padding()
//        }
//        .onTapGesture {
//            isA.toggle()
//        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
        // 添加不同设备进行预览
//        Group {
//            TestView().previewDevice("iPhone 8")
//            TestView().previewDevice("iPhone XR")
//        }
    }
}
