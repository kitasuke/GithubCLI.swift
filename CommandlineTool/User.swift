//
//  User.swift
//  CommandlineTool
//
//  Created by Yusuke Kita on 7/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Commandant
import Result
import CommandlineToolKit

struct UserCommand: CommandType {
    typealias ClientError = CommandlineToolError
    
    let verb = "user"
    let function = "Search Github users"
    
    func run(mode: CommandMode) -> Result<(), CommandantError<ClientError>> {
        return UserOptions.evaluate(mode).flatMap { options in
            let arguments = Process.arguments
            if arguments.count < 4 {
                return .failure(.UsageError(description: "Invalid arguments"))
            }
            
            let requiredArguments = [
                "-name"
            ]
            for argument in requiredArguments {
                if find(arguments, argument) == nil {
                    return .failure(.UsageError(description: "\(argument) argument required"))
                }
            }
            
            let runLoop = CFRunLoopGetCurrent()
            
            let names = split(arguments, allowEmptySlices: true) { $0 == "-name" }.last
            if let name = names?.first {
                APIClient.sharedClient.searchUser(name, completionHandler: { result in
                    CFRunLoopStop(runLoop)
                })
            }
            CFRunLoopRun()
            
            return .success()
        }
    }
}

struct UserOptions: OptionsType {
    let name: String
    
    static func create(name: String) -> UserOptions {
        return self(name: name)
    }
    
    static func evaluate(m: CommandMode) -> Result<UserOptions, CommandantError<CommandlineToolError>> {
        return create
            <*> m <| Option(key: "username", defaultValue: "", usage: "user's name to search")
    }
}