//
//  UserDetails.swift
//  TestGitUsers
//
//  Created by Ira Golubovich on 2/18/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation

struct UserDetails: Decodable {
    let avatar_url: String?
    let name: String?
    let email: String?
    let company: String?
    let following: Int?
    let followers: Int?
    let created_at: String
}
