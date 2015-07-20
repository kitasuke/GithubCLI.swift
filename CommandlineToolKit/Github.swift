//
//  Github
//  CommandlineTool
//
//  Created by Yusuke Kita on 7/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import Result
import APIKit

public class Github: API {
    override public class var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
    
    public class Endpoint {
        // https://developer.github.com/v3/search/#search-users
        public class SearchUsers: APIKit.Request {
            public enum Sort: String {
                case Followers = "followers"
                case Repositories = "repositories"
                case Joined = "joined"
            }
            
            public enum Order: String {
                case Ascending = "asc"
                case Descending = "desc"
            }
            
            public typealias Response = [AnyObject]
            
            let query: String
            let sort: Sort
            let order: Order
            
            public var URLRequest: NSURLRequest? {
                return Github.URLRequest(
                    method: .GET,
                    path: "/search/users",
                    parameters: ["q": query, "sort": sort.rawValue, "order": order.rawValue]
                )
            }
            
            public init(query: String, sort: Sort = .Followers, order: Order = .Ascending) {
                self.query = query
                self.sort = sort
                self.order = order
            }
            
            public class func responseFromObject(object: AnyObject) -> Response? {
                return object["items"] as? Response
            }
        }
        
        // https://developer.github.com/v3/search/#search-repositories
        public class SearchRepositories: APIKit.Request {
            public enum Sort: String {
                case Followers = "followers"
                case Repositories = "repositories"
                case Joined = "joined"
            }
            
            public enum Order: String {
                case Ascending = "asc"
                case Descending = "desc"
            }
            
            public typealias Response = [AnyObject]
            
            let query: String
            let sort: Sort
            let order: Order
            
            public var URLRequest: NSURLRequest? {
                return Github.URLRequest(
                    method: .GET,
                    path: "/search/repositories",
                    parameters: ["q": query, "sort": sort.rawValue, "order": order.rawValue]
                )
            }
            
            public init(query: String, sort: Sort = .Followers, order: Order = .Ascending) {
                self.query = query
                self.sort = sort
                self.order = order
            }
            
            public class func responseFromObject(object: AnyObject) -> Response? {
                return object["items"] as? Response
            }
        }
    }
}