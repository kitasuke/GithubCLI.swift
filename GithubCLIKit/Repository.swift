//
//  Repository.swift
//  GithubCLI
//
//  Created by Yusuke Kita on 10/3/15.
//  Copyright © 2015 kitasuke. All rights reserved.
//

import Foundation
import Himotoki

public struct Repository: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let description: String
    let language: String
    let watchersCount: Int
    let stargazersCount: Int
    let forksCount: Int
    let url: String
    let htmlURL: String
    let createdAt: String
    let updatedAt: String
    
    public static func decode(e: Extractor) throws -> Repository {
        return try build(self.init)(
            e <| "id",
            e <| "name",
            e <| "full_name",
            e <| "description",
            e <| "language",
            e <| "watchers_count",
            e <| "stargazers_count",
            e <| "forks_count",
            e <| "url",
            e <| "html_url",
            e <| "created_at",
            e <| "updated_at"
        )
    }
}