//
//  Post.swift
//  original
//
//  Created by 関戸さき on 2025/01/24.
//

import Foundation

//struct Post: Codable {
//    let id: String
//    let title: String
//    let userId: String
//    let postImages: [String]
//    let thumbnailPost: String
//    let createdAt: String
//}

struct Post: Codable {
    let id: String
    let profileImage: String
    let username: String
    let postImage: String
}

// MARK: - ダミーデータ
struct DummyData {
    static let posts: [Post] = [
        Post(id: "1", profileImage: "profile1", username: "Alice", postImage: "post1"),
        Post(id: "2", profileImage: "profile2", username: "Bob", postImage: "post2"),
        Post(id: "3", profileImage: "profile3", username: "Charlie", postImage: "post3"),
        Post(id: "4", profileImage: "profile4", username: "Diana", postImage: "post4")
    ]
}

