//
//  User.swift
//  TestGitUsers
//
//  Created by Ira Golubovich on 2/18/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation

struct User: Decodable {
    let avatar_url: String?
    let login: String
    let id: Int
}
