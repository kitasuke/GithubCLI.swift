//
//  User.swift
//  GithubCLI
//
//  Created by Yusuke Kita on 7/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Commandant
import Result
import GithubCLIKit

struct UserCommand: CommandType {
    typealias ClientError = GithubCLIError
    
    let verb = "user"
    let function = "Search Github users"
    
    func run(mode: CommandMode) -> Result<(), CommandantError<ClientError>> {
        return UserOptions.evaluate(mode).flatMap { options in
            let arguments = Process.arguments
            guard arguments.count > 3 else { return .Failure(.UsageError(description: "Invalid arguments")) }
            
            let requiredArguments = [
                "-name"
            ]
            for argument in requiredArguments {
                guard let _ = arguments.indexOf(argument) else { return .Failure(.UsageError(description: "\(argument) argument required")) }
            }
            
            let argument = arguments.split { $0 == "-name" }.last
            guard let name = argument?.first else { return .Failure(.UsageError(description: "Invalid input name")) }
            
            let runLoop = CFRunLoopGetCurrent()
            APIClient.sharedClient.searchUsers(name, completionHandler: { result in
                switch result {
                case .Success(let users): print(users)
                case .Failure(let error): print(error)
                }
                CFRunLoopStop(runLoop)
            })
            CFRunLoopRun()
            
            return .Success(())
        }
    }
}

struct UserOptions: OptionsType {
    let name: String
    
    static func create(name: String) -> UserOptions {
        return self.init(name: name)
    }
    
    static func evaluate(m: CommandMode) -> Result<UserOptions, CommandantError<GithubCLIError>> {
        return create
            <*> m <| Option(key: "username", defaultValue: "", usage: "user's name to search")
    }
}