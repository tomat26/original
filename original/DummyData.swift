//
//  DummyDeta.swift
//  original
//
//  Created by 関戸さき on 2024/12/06.
//

import Foundation

// MARK: - ダミーデータの構造体
struct Post {
    let profileImage: String
    let username: String
    let postImage: String
}

// MARK: - ダミーデータ
struct DummyData {
    static let posts: [Post] = [
        Post(profileImage: "profile1", username: "Alice", postImage: "post1"),
        Post(profileImage: "profile2", username: "Bob", postImage: "post2"),
        Post(profileImage: "profile3", username: "Charlie", postImage: "post3"),
        Post(profileImage: "profile4", username: "Diana", postImage: "post4")
    ]
}



