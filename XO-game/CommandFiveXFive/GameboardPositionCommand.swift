//
//  GameboardPositionCommand.swift
//  XO-game
//
//  Created by Anton Hodyna on 04/04/2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation


protocol Command {
    func execute(with interval: Double)
}

class AddXMarkViewCoommand: Command {
    
    private var position: GameboardPosition
    private var gameboardView: GameboardView
    private var timer = Timer()
    
    func execute(with interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.gameboardView.removeMarkView(at: self.position)
            self.gameboardView.placeMarkView(XView(), at: self.position)
        }
    }
    
    init(position: GameboardPosition, gameboardView: GameboardView) {
        self.position = position
        self.gameboardView = gameboardView
    }
}

class AddOMarkViewCoommand: Command {
    
    private var position: GameboardPosition
    private var gameboardView: GameboardView
    private var timer = Timer()
    
    func execute(with interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.gameboardView.removeMarkView(at: self.position)
            self.gameboardView.placeMarkView(OView(), at: self.position)
        }
    }
    
    init(position: GameboardPosition, gameboardView: GameboardView) {
        self.position = position
        self.gameboardView = gameboardView
    }
}


//MARK: - Invoker

class GameBoardPositionsInvoker {
    
    private let xPositionsMaxCount = 5
    private let oPositionsMaxCount = 5
    
    var timer = Timer()
    
    private var firstPlayerComands: [Command] = []
    private var secondPlayerComands: [Command] = []
    
    func addComand(comand: Command) {
        if firstPlayerComands.count < 5 {
            firstPlayerComands.append(comand)
        } else {
            secondPlayerComands.append(comand)
        }
    }
    
    func comandsCount() -> Int {
        return firstPlayerComands.count + secondPlayerComands.count
    }
    
    func addMarksOnBoard () {
        if comandsCount() >= 10 {
            let comands = buildComandsArray()
            var interval = 0.0
            for comand in comands {
                comand.execute(with: interval)
                interval += 1
            }
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
