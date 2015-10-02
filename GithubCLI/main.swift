//
//  main.swift
//  GithubCLI
//
//  Created by Yusuke Kita on 7/19/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Commandant

let registry = CommandRegistry<GithubCLIError>()
registry.register(VersionCommand())
registry.register(UserCommand())
registry.register(RepositoryCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}