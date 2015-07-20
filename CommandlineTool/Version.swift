//
//  VersionCommand.swift
//  CommandlineTool
//
//  Created by Yusuke Kita on 2015-05-20.
//  Copyright (c) 2015 kitasuke All rights reserved.
//

import Commandant
import Result
import let CommandlineToolKit.CommandlineToolKitBundleIdentifier

struct VersionCommand: CommandType {
    typealias ClientError = CommandlineToolError
    let verb = "version"
    let function = "Display the current version of CommandlineTool"

    func run(mode: CommandMode) -> Result<(), CommandantError<CommandlineToolError>> {
        switch mode {
        case .Arguments:
            let version = NSBundle(identifier: CommandlineToolKitBundleIdentifier)?.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
            println(version!)
        default:
            break
        }
        return .success(())
    }
}
