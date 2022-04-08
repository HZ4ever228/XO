//
//  GameBoardPositionsInvoker.swift
//  XO-game
//
//  Created by Anton Hodyna on 05/04/2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class GameBoardPositionsInvoker {
    
    private let xPositionsMaxCount = 5
    private let oPositionsMaxCount = 5
    
    private var firstPlayerComands: [Command] = []
    private var secondPlayerComands: [Command] = []
    
    var gamaIsEnd = false
    
    func addComand(comand: Command) {
        if firstPlayerComands.count < 5 {
            firstPlayerComands.append(comand)
        } else {
            secondPlayerComands.append(comand)
        }
    }
    
    func firstPlayerComandCount() -> Int {
        return firstPlayerComands.count
    }
    
    func secondPlayerComandsCount() -> Int {
        return secondPlayerComands.count
    }
    
    func comandsCount() -> Int {
        return firstPlayerComandCount() + secondPlayerComandsCount()
    }
    
    func addMarksOnBoard () {
        if comandsCount() >= 10 {
            let comands = buildComandsArray()
            var interval = 0.0
            for comand in comands {
                comand.execute(with: interval)
                interval += 1
            }
            gamaIsEnd = true
        } else {
            return
        }
    }
    
    func buildComandsArray() -> [Command] {
        var comands: [Command] = []
        while comands.count < 10 {
            comands.append(firstPlayerComands.first!)
            firstPlayerComands.removeFirst()
            comands.append(secondPlayerComands.first!)
            secondPlayerComands.removeFirst()
        }
        return comands
    }
}
