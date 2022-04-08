//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Anton Hodyna on 04/04/2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class ComputerInputState: PlayerInputState {
    
    func computerAddMark() -> GameboardPosition? {
        guard let gameboardView = gameboardView else { return nil }
        
        var position = generatePosition()
        
        while !gameboardView.canPlaceMarkView(at: position) {
            position = generatePosition()
        }
        return position
        
    }
    
    func generatePosition() -> GameboardPosition {
        var columns: [Int] = []
        var rows: [Int] = []
        for value in 1...GameboardSize.columns {
            columns.append(value - 1)
        }
        for value in 1...GameboardSize.rows {
            rows.append(value - 1)
        }
        
        return GameboardPosition.init(column: columns.randomElement() ?? 0, row: rows.randomElement() ?? 0)
    }
    
}
