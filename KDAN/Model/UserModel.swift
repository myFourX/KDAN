//
//  UserModel.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let avatar_url: String
    let site_admin: Bool
}

struct UserDetail: Codable {
    let login: String
    let avatar_url: String
    let bio: String?
    let location: String?
    let email: String?
    let followers: Int
    let following: Int
}
