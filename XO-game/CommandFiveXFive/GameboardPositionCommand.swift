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
    private var gameboard: Gameboard
    private var timer = Timer()
    
    func execute(with interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.gameboardView.removeMarkView(at: self.position)
            self.gameboardView.placeMarkView(XView(), at: self.position)
            self.gameboard.setPlayer(.first, at: self.position)
        }
    }
    
    init(position: GameboardPosition, gameboardView: GameboardView,  gameboard: Gameboard) {
        self.position = position
        self.gameboardView = gameboardView
        self.gameboard = gameboard
    }
}

class AddOMarkViewCoommand: Command {
    
    private var position: GameboardPosition
    private var gameboardView: GameboardView
    private var gameboard: Gameboard
    private var timer = Timer()
    
    func execute(with interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.gameboardView.removeMarkView(at: self.position)
            self.gameboardView.placeMarkView(OView(), at: self.position)
            self.gameboard.setPlayer(.first, at: self.position)
        }
    }
    
    init(position: GameboardPosition, gameboardView: GameboardView, gameboard: Gameboard) {
        self.position = position
        self.gameboardView = gameboardView
        self.gameboard = gameboard
    }
}
