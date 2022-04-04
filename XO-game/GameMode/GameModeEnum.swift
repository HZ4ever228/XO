//
//  GameModeEnum.swift
//  XO-game
//
//  Created by Anton Hodyna on 04/04/2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

enum GameDifficulty {
    case easy
    case hard
}

enum GameModeEnum {
    case singlePlayer(difficulty: GameDifficulty)
    case multiPlayer
}
