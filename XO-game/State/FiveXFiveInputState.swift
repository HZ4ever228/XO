//
//  FiveXFiveInputState.swift
//  XO-game
//
//  Created by Anton Hodyna on 05/04/2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class FiveXFiveInputState: GameState {
    
    // MARK: - Properties
    
    let markViewPrototype: MarkView
    
    private(set) var isCompleted = false
    
    let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private(set) weak var invoker: GameBoardPositionsInvoker?
    
    // MARK: - Construction
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, invoker: GameBoardPositionsInvoker) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.invoker = invoker
    }
    
    // MARK: - Functions
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        
        guard let gameboardView = gameboardView, let gameboard = gameboard else {
            return
        }
        
        if !gameboard.contains(player: player, at: position) {
            gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        }
        addComandToInvoker(position: position)
        //gameboard.setPlayer(player, at: position)
       
        if checkPlayersComandsCount() == 5 {
            isCompleted = true
        }
    }
    
    func checkPlayersComandsCount() -> Int {
        switch player {
        case .first:
            return invoker?.firstPlayerComandCount() ?? 0
        case .second:
            return invoker?.secondPlayerComandsCount() ?? 0
        }
    }
    
    func addComandToInvoker(position: GameboardPosition) {
        guard let gameboardView = gameboardView, let gameboard = gameboard else { return }
        switch player {
        case .first:
            let addXMarkViewCommand = AddXMarkViewCoommand(position: position, gameboardView: gameboardView, gameboard: gameboard)
            invoker?.addComand(comand: addXMarkViewCommand)
        case .second:
            let addOMarkViewCommand = AddOMarkViewCoommand(position: position, gameboardView: gameboardView, gameboard: gameboard)
            invoker?.addComand(comand: addOMarkViewCommand)
        }
    }
}
