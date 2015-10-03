//
//  User.swift
//  GithubCLI
//
//  Created by Yusuke Kita on 10/3/15.
//  Copyright © 2015 kitasuke. All rights reserved.
//

import Foundation
import Himotoki

public struct User: Decodable {
    let id: Int
    let name: String
    let url: String
    let htmlURL: String
    let avatarURL: String
    
    public static func decode(e: Extractor) throws -> User {
        return try build(self.init)(
            e <| "id",
            e <| "login",
            e <| "url",
            e <| "html_url",
            e <| "avatar_url"
        )
    }
}