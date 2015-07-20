//
//  APIClient.swift
//  CommandlineTool
//
//  Created by Yusuke Kita on 7/19/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import Result
import APIKit

/// CommandlineToolKit’s bundle identifier.
public let CommandlineToolKitBundleIdentifier = NSBundle(forClass: APIClient.self).bundleIdentifier!

public class APIClient {
    static public let sharedClient = APIClient()
    
    public func searchUser(user: String, completionHandler: (Bool -> Void)) {
        let request = Github.Endpoint.SearchUsers(query: user, sort: .Followers, order: .Ascending)
        Github.sendRequest(request) { result in
            switch result {
            case .Success(let box):
                println(box)
                completionHandler(true)
            case .Failure(let box):
                println(box)
                completionHandler(false)
            }
        }
    }
    
    public func searchRepository(repository: String, completionHandler: (Bool -> Void)) {
        let request = Github.Endpoint.SearchRepositories(query: repository, sort: .Followers, order: .Ascending)
        Github.sendRequest(request) { result in
            switch result {
            case .Success(let box):
                println(box)
                completionHandler(true)
            case .Failure(let box):
                println(box)
                completionHandler(false)
            }
        }
    }
}