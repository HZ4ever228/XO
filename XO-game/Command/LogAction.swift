//
//  LogAction.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 31.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public enum LogAction {
    case playerInput(player: Player, position: GameboardPosition)
    case gameFinished(winner: Player?)
    case restart
}

public func log(_ action: LogAction) {
    let action = LogCommand(action: action)
    LoggerInvoker.shared.addLogCommand(action)
}
