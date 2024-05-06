//
//  PandoraGame+Override.swift
//  CupGame
//
//  Created by Yongye on 5/6/24.
//

import SpriteKit

extension PandoraGameScene {
    
    override func didMove(to view: SKView) {
        initalizeGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // don't allow tapping when it is not done animating
        if self.isAnimating {
            return
        }
        
        
        // if game has not started, then start shuffling the cups
        if !isGameStarted {
            isAnimating = true
            makeSkeletonDisappear()
            isGameStarted = true
            
        } else { // game has started, then start picking the cup
            
            // get the first touch of the user
            guard let touch = touches.first else { return }
            
            // get the location of the touch
            let location = touch.location(in: self)
            
            
            // loop through the cups to see if the location match
            for (index, box) in boxes.enumerated() {
                
                let y_dist = abs(box.position.y - location.y)
                let x_dist = abs(box.position.x - location.x)
                
                if x_dist <= 80 && y_dist <= 60 {
                    revealBoxes(index)
                }
                
            }
            
        }
    }
    
}
