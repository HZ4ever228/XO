//
//  LoggerInvoker.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 31.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class LoggerInvoker {
    
    static let shared = LoggerInvoker()
    
    private let logger = Logger()
    private let batchSize = 10
    private var commands: [LogCommand] = []
    
    func addLogCommand(_ command: LogCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }
    
    private func executeCommandsIfNeeded() {
        guard commands.count >= batchSize else {
            return
        }
        
        commands.forEach { self.logger.writeMessageToLog($0.logMessage) }
        commands = []
    }
}
