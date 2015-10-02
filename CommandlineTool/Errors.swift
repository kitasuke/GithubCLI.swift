//
//  Errors.swift
//  CommandlineTool
//
//  Created by Yusuke Kita on 2015-05-20.
//  Copyright (c) 2015 kitasuke All rights reserved.
//

import Commandant
import Box

/// Possible errors within CommandlineTool.
enum CommandlineToolError: CustomStringConvertible {
    case InvalidArgument(description: String)
    case ConnectionFailed
    case TaskError(terminationStatus: Int32)

    var description: String {
        switch self {
        case let .InvalidArgument(description):
            return description
        case .ConnectionFailed:
            return "Failed to connect to API."
        case .TaskError:
            return "A shell task exited unsuccessfully."
        }
    }
}

func toCommandantError(commandlineToolError: CommandlineToolError) -> CommandantError<CommandlineToolError> {
    return .CommandError(commandlineToolError)
}
