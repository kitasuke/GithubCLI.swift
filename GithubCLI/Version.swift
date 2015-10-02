//
//  VersionCommand.swift
//  GithubCLI
//
//  Created by Yusuke Kita on 2015-05-20.
//  Copyright (c) 2015 kitasuke All rights reserved.
//

import Commandant
import Result
import let GithubCLIKit.GithubCLIKitBundleIdentifier

struct VersionCommand: CommandType {
    typealias ClientError = GithubCLIError
    let verb = "version"
    let function = "Display the current version of CommandlineTool"

    func run(mode: CommandMode) -> Result<(), CommandantError<GithubCLIError>> {
        switch mode {
        case .Arguments:
            let version = NSBundle(identifier: GithubCLIKitBundleIdentifier)?.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
            print(version!)
        default:
            break
        }
        return .Success(())
    }
}
