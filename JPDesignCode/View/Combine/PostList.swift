//
//  PostList.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/7/29.
//

import SwiftUI

// 没使用Combine的情况
//struct PostList: View {
//    @State var posts: [Post] = []
//
//    var body: some View {
//        List(posts) { post in
//            Text(post.title)
//        }
//        .onAppear {
//            Api().getPosts { posts in
//                self.posts = posts
//            }
//        }
//    }
//}

struct PostList: View {
    @ObservedObject var store = PostStore()

    var body: some View {
        List(store.posts) { post in
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.system(.title, design: .serif))
                    .bold()
                Text(post.body)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        PostList()
    }
}
