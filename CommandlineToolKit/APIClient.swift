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

public enum APIClientError: ErrorType {
    case APIError
}

/// CommandlineToolKit’s bundle identifier.
public let CommandlineToolKitBundleIdentifier = NSBundle(forClass: APIClient.self).bundleIdentifier!

public class APIClient {
    static public let sharedClient = APIClient()
    
    public func searchUsers(name: String, completionHandler: (Result<[AnyObject], APIClientError> -> Void)) {
        let request = SearchUsers(query: name)
        API.sendRequest(request) { result in
            switch result {
            case .Success(let users):
                completionHandler(.Success(users))
            case .Failure(_):
                completionHandler(.Failure(.APIError))
            }
        }
    }
    
    public func searchRepositories(name: String, completionHandler: (Result<[AnyObject], APIClientError> -> Void)) {
        let request = SerchRepositories(query: name)
        API.sendRequest(request) { result in
            switch result {
            case .Success(let repositories):
                completionHandler(.Success(repositories))
            case .Failure(_):
                completionHandler(.Failure(.APIError))
            }
        }
    }
}