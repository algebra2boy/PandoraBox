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
        
        // don't allow tapping when it is still animating
        if self.isAnimating {
            return
        }
        
        // if game has not started, then start shuffling the boxes
        if !isGameStarted {
            isAnimating = true
            moveSkeleton(.down)
            isGameStarted = true
        } else { // game has started, then start picking the box
            
            // get the first touch of the user
            guard let touch = touches.first else { return }
            
            // get the location of the touch
            let location = touch.location(in: self)
            
            
            // loop through the boxes to see if the location match
            for (index, box) in boxes.enumerated() {
                
                let y_dist = abs(box.position.y - location.y)
                let x_dist = abs(box.position.x - location.x)
                
                if x_dist <= 80 && y_dist <= 60 {
                    revealBoxes(at: index)
                }
                
            }
            
        }
    }
    
}
