//
//  Repository.swift
//  CommandlineTool
//
//  Created by Yusuke Kita on 7/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import CommandlineToolKit
import Commandant
import Result

struct RepositoryCommand: CommandType {
    typealias ClientError = CommandlineToolError
    
    let verb = "repository"
    let function = "Search repository on Github"
    
    func run(mode: CommandMode) -> Result<(), CommandantError<ClientError>> {
        return RepositoryOptions.evaluate(mode).flatMap { options in
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
            
            let repositories = split(arguments, allowEmptySlices: true) { $0 == "-name" }.last
            if let name = repositories?.first {
                APIClient.sharedClient.searchRepository(name, completionHandler: { result in
                    CFRunLoopStop(runLoop)
                })
            }
            CFRunLoopRun()
            
            return .success()
        }
    }
}

struct RepositoryOptions: OptionsType {
    let name: String
    
    static func create(name: String) -> RepositoryOptions {
        return self(name: name)
    }
    
    static func evaluate(m: CommandMode) -> Result<RepositoryOptions, CommandantError<CommandlineToolError>> {
        return create
            <*> m <| Option(key: "repository name", defaultValue: "", usage: "repository name to search")
    }
}