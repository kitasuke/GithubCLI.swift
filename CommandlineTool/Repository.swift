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
            APIClient.sharedClient.searchRepositories(name, completionHandler: { result in
                switch result {
                case .Success(let repositories):
                    print(repositories)
                case .Failure(let error):
                    print(error)
                }
                CFRunLoopStop(runLoop)
            })
            CFRunLoopRun()
            
            return .Success()
        }
    }
}

struct RepositoryOptions: OptionsType {
    let name: String
    
    static func create(name: String) -> RepositoryOptions {
        return self.init(name: name)
    }
    
    static func evaluate(m: CommandMode) -> Result<RepositoryOptions, CommandantError<CommandlineToolError>> {
        return create
            <*> m <| Option(key: "repository name", defaultValue: "", usage: "repository name to search")
    }
}