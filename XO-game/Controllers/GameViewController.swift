//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Public Properties
    
    public var gameMode: GameModeEnum?
    
    // MARK: - Outlets
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    // MARK: - Private Properties
    
    private lazy var referee = Referee(gameboard: gameboard)
    private lazy var invoker = GameBoardPositionsInvoker()
    
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToFirsState()
        configureGame()
    }
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restart)
    }
    
    // MARK: - Private Functions
    
    private func configureGame() {
        guard let gameMode = gameMode else { return }
        switch gameMode {
            
        case .multiPlayer(let mode):
            switch mode {
            case .normal:
                configureForSinglePlayerOrNormalMultiplayer()
            case .fiveXFive:
                configureFor5x5()
            }
        case .singlePlayer(_):
            configureForSinglePlayerOrNormalMultiplayer()
        }
    }
    
    private func configureFor5x5(){
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else {
                return
            }
            print("position: \(position)")
            let comandCount = self.invoker.comandsCount()
            if comandCount < 5 {
                if !self.gameboard.contains(player: .first, at: position) {
                    self.gameboardView.placeMarkView(XView(), at: position)
                    let addXMarkViewCommand = AddXMarkViewCoommand(position: position, gameboardView: self.gameboardView)
                    self.invoker.addComand(comand: addXMarkViewCommand)
                }
            } else if comandCount == 5 {
                self.gameboardView.clear()
                let addOMarkViewCommand = AddOMarkViewCoommand(position: position, gameboardView: self.gameboardView)
                self.invoker.addComand(comand: addOMarkViewCommand)
                self.gameboardView.placeMarkView(OView(), at: position)
            } else if comandCount > 5 && comandCount < 10 {
                if !self.gameboard.contains(player: .second, at: position) {
                    self.gameboardView.placeMarkView(OView(), at: position)
                    let addOMarkViewCommand = AddOMarkViewCoommand(position: position, gameboardView: self.gameboardView)
                    self.invoker.addComand(comand: addOMarkViewCommand)
                }
            } else if comandCount == 10 {
                self.gameboardView.clear()
                self.invoker.addMarksOnBoard()
                if let winner = self.referee.determineWinner() {
                    self.currentState = GameEndedState(winner: winner, gameViewController: self)
                    return
                }
            }
            
//            if self.currentState.isCompleted {
//                self.goToNextState()
//            }
        }
    }
    
    private func configureForSinglePlayerOrNormalMultiplayer() {
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else {
                return
            }
            
            self.currentState.addMark(at: position)
            
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    private func goToFirsState() {
        let player = Player.first
        currentState = PlayerInputState(player: .first,
                                        markViewPrototype: player.markViewPrototype,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if let gameMode = gameMode {
            switch gameMode {
                
            case .singlePlayer(let difficulty):
                
                if let playerInputState = currentState as? PlayerInputState {
                    let computer = playerInputState.player.next
                    currentState = ComputerInputState(
                        player: computer,
                        markViewPrototype: computer.markViewPrototype,
                        gameViewController: self,
                        gameboard: gameboard,
                        gameboardView: gameboardView)
                    
                    
                    if computer == .second, let computerMarkPosition = (currentState as? ComputerInputState)?.computerAddMark() {
                        gameboardView.placeMarkView(computer.markViewPrototype, at: computerMarkPosition)
                        goToNextState()
                    }
                    
                } else if let playerInputState = currentState as? ComputerInputState {
                    let player = playerInputState.player.next
                    currentState = PlayerInputState(
                        player: player,
                        markViewPrototype: player.markViewPrototype,
                        gameViewController: self,
                        gameboard: gameboard,
                        gameboardView: gameboardView)
                }
                    
            case .multiPlayer(let mode):
                if let playerInputState = currentState as? PlayerInputState {
                    let player = playerInputState.player.next
                    currentState = PlayerInputState(
                        player: player,
                        markViewPrototype: player.markViewPrototype,
                        gameViewController: self,
                        gameboard: gameboard,
                        gameboardView: gameboardView)
                }
            }
        }
    }
    
    
}

