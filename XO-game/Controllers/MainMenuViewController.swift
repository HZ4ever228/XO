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
    
    @IBOutlet weak var gameModeSegmentedControl: UISegmentedControl! {
        didSet {
            gameModeSegmentedControl.selectedSegmentIndex = 1
        }
    }
    @IBOutlet weak var difficultyLevelSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var gameDifficultyStackView: UIStackView! {
        didSet {
            gameDifficultyStackView.isHidden = true
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Private Properties
    
    private var gameMode = GameModeEnum.multiPlayer
    
    //MARK: - Actions
    
    @IBAction func gameModeSegmentControlAction(_ sender: Any) {
        switch gameModeSegmentedControl.selectedSegmentIndex {
        case 0:
            gameDifficultyStackView.isHidden = false
            
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
            gameMode = .multiPlayer
        default:
            break
        }
    }
    
    //MARK: - Functions
    
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
