//
//  MainMenuViewController.swift
//  XO-game
//
//  Created by Anton Hodyna on 04/04/2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var gameModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var difficultyLevelSegmentedControl: UISegmentedControl!
    @IBOutlet weak var multiplayerGameModeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var gameDifficultyStackView: UIStackView!
    @IBOutlet weak var multiplayerGameModeStackView: UIStackView!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstConfigure()
    }
    
    // MARK: - Private Properties
    
    private var gameMode = GameModeEnum.singlePlayer(difficulty: .easy)
    
    //MARK: - Actions
    
    @IBAction func gameModeSegmentControlAction(_ sender: Any) {
        switch gameModeSegmentedControl.selectedSegmentIndex {
        case 0:
            gameDifficultyStackView.isHidden = false
            multiplayerGameModeStackView.isHidden = true
            
            switch difficultyLevelSegmentedControl.selectedSegmentIndex {
            case 0:
                gameMode = .singlePlayer(difficulty: .easy)
            case 1:
                gameMode = .singlePlayer(difficulty: .hard)
            default:
                break
            }
            
        case 1:
            gameDifficultyStackView.isHidden = true
            multiplayerGameModeStackView.isHidden = false
            
            switch multiplayerGameModeSegmentedControl.selectedSegmentIndex {
            case 0:
                gameMode = .multiPlayer(mode: .normal)
            case 1:
                gameMode = .multiPlayer(mode: .fiveXFive)
            default:
                break
            }
        default:
            break
        }
    }
    
    @IBAction func difficultyLevelSegmentControllAction(_ sender: Any) {
        switch difficultyLevelSegmentedControl.selectedSegmentIndex {
        case 0:
            gameMode = .singlePlayer(difficulty: .easy)
        case 1:
            gameMode = .singlePlayer(difficulty: .hard)
        default:
            break
        }
    }
    
    @IBAction func multiplayerGameModeSegmentControlAction(_ sender: Any) {
        switch multiplayerGameModeSegmentedControl.selectedSegmentIndex {
        case 0:
            gameMode = .multiPlayer(mode: .normal)
        case 1:
            gameMode = .multiPlayer(mode: .fiveXFive)
        default:
            break
        }
    }
    
    
    //MARK: - Functions
    
    private func firstConfigure() {
        gameModeSegmentedControl.selectedSegmentIndex = 0
        multiplayerGameModeStackView.isHidden = true
        difficultyLevelSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToGameViewController":
            guard let destanation = segue.destination as? GameViewController else { return }
            destanation.gameMode = gameMode
            
        default:
            break
        }
    }
}
