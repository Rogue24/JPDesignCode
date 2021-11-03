//
//  PostStore.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/8/2.
//

import SwiftUI
import Combine

class PostStore: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        Api().getPosts { posts in
            self.posts = posts
        }
    }
}

class Api {
    func getPosts(completion: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "http://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("请求失败")
                DispatchQueue.main.async { completion([Post(title: "请求失败", body: "网络错误")]) }
                return
            }

            do {
                print("请求成功")
                let posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async { completion(posts) }
            } catch let error {
                print("请求失败 \(error)")
                DispatchQueue.main.async { completion([Post(title: "解析失败", body: "部分字段解析错误")]) }
            }
        }
        .resume()
    }
}
