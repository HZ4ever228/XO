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
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restart)
    }
    
    // MARK: - Private Functions
    
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
                    
            case .multiPlayer:
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

