//
//  Github
//  GithubCLIKit
//
//  Created by Yusuke Kita on 7/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import Result
import APIKit

public protocol GithubRequest: Request {
    
}

public extension GithubRequest {
    public var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
}

public enum Sort: String {
    case Followers = "followers"
    case Repositories = "repositories"
    case Joined = "joined"
}

public enum Order: String {
    case Ascending = "asc"
    case Descending = "desc"
}

public struct SearchUsers: GithubRequest {
    public typealias Response = [AnyObject]
    
    let query: String
    let sort: Sort
    let order: Order
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var path: String {
        return "/search/users"
    }
    
    public var parameters: [String: AnyObject] {
        return ["q": query, "sort": sort.rawValue, "order": order.rawValue]
    }
    
    public init(query: String, sort: Sort = .Followers, order: Order = .Ascending) {
        self.query = query
        self.sort = sort
        self.order = order
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let dictionary = object as? [String: AnyObject] else { return nil }
        guard let users = dictionary["items"] as? [AnyObject] else { return nil }
        return users
    }
}

public struct SerchRepositories: GithubRequest {
    public typealias Response = [[String: AnyObject]]
    
    let query: String
    let sort: Sort
    let order: Order
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var path: String {
        return "/search/repositories"
    }
    
    public var parameters: [String: AnyObject] {
        return ["q": query, "sort": sort.rawValue, "order": order.rawValue]
    }
    
    public init(query: String, sort: Sort = .Followers, order: Order = .Ascending) {
        self.query = query
        self.sort = sort
        self.order = order
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let dictionary = object as? [String: AnyObject] else { return nil }
        guard let repositories = dictionary["items"] as? [[String: AnyObject]] else { return nil }
        return repositories
    }
}