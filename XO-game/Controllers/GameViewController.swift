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
    var timer = Timer()
    
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
                goToFirsState()
                configureForSinglePlayerOrNormalMultiplayer()
            case .fiveXFive:
                goToFirs5x5State()
                configureFor5x5()
            }
        case .singlePlayer(_):
            goToFirsState()
            configureForSinglePlayerOrNormalMultiplayer()
        }
    }
    
    //MARK: - 5x5 Multiplayer
    
    private func goToFirs5x5State() {
        let player = Player.first
        currentState = FiveXFiveInputState(player: .first,
                                        markViewPrototype: player.markViewPrototype,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView,
                                        invoker: invoker)
    }
    
    private func configureFor5x5(){
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else {
                return
            }
            
            self.currentState.addMark(at: position)
            
            if self.currentState.isCompleted {
                self.goToNext5x5State()
            }
        }
    }
    
    private func goToNext5x5State() {
        if invoker.comandsCount() == 10 {
            gameboardView.clear()
            invoker.addMarksOnBoard()
            
            timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if self.invoker.gamaIsEnd {
                    if let winner = self.referee.determineWinner() {
                        self.currentState = GameEndedState(winner: winner, gameViewController: self)
                        return
                    } else {
                        print("there is no winner")
                    }
                } else {
                    print("game is not end")
                }
            }
            
            
        } else {
            if let playerInputState = currentState as? FiveXFiveInputState {
                let player = playerInputState.player.next
                currentState = FiveXFiveInputState(
                    player: player,
                    markViewPrototype: player.markViewPrototype,
                    gameViewController: self,
                    gameboard: gameboard,
                    gameboardView: gameboardView,
                    invoker: invoker)
                gameboardView.clear()
            }
        }
        
    }
    
    //MARK: - Single Player or normal Multiplayer
    
    private func goToFirsState() {
        let player = Player.first
        currentState = PlayerInputState(player: .first,
                                        markViewPrototype: player.markViewPrototype,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView)
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

