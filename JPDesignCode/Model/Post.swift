//
//  Post.swift
//  JPDesignCode
//
//  Created by aa on 2021/10/28.
//

import SwiftUI

struct Post: Codable, Identifiable {
    let id = UUID()
    var title: String
    var body: String
    
    // Identifiable需要id字段，并且id要有唯一固定值，所以不用var修饰
    // 但会有Codable的警告：没有CodingKeys时希望存储属性都是var修饰
    // 由于json数据也有id字段，这样会造成解析json数据时，发现id字段类型不一样，导致解码失败。
    // 定义一个显式CodingKeys枚举以防止id解码，同时也可以移除Codable警告
    private enum CodingKeys: String, CodingKey {
        case title, body // 这里放入需要解码的字段，没有的不解码，所以id可以用let修饰了
    }
}
