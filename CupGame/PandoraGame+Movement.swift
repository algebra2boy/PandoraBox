//
//  PandoraGame+Movement.swift
//  CupGame
//
//  Created by Yongye on 5/6/24.
//

import SpriteKit

extension PandoraGameScene {
    
    func makeSkeletonDisappear() {
        
        // create a move action
        let actionMoveDown = SKAction.moveBy(x: 0, y: -100, duration: 0.5)
        
        // create a fade out action so the ghost seems like disappearing
        let actionFadeOut = SKAction.fadeOut(withDuration: 2)
        
        // combine the move and fade out actions
        let groupAction = SKAction.group([actionMoveDown, actionFadeOut])
        
        // remove the skeleton from the scene
        let removeAction = SKAction.removeFromParent()
        
        // combine the move, fadeout, and remove
        let actions = SKAction.sequence([groupAction, removeAction])
        
        skeleton.run(actions, completion: playWalkthrough)
        
    }
    
    func makeSkeletonAppear() {
        
        // create a move action
        let actionMoveUp = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
        
        // create a fade out action so the ghost seems like appearing
        let actionFadeOut = SKAction.fadeOut(withDuration: 2)
        
        // combine the move and fade out actions
        let groupAction = SKAction.group([actionMoveUp, actionFadeOut])
        
        // remove the skeleton from the scene
        let removeAction = SKAction.removeFromParent()
        
        // combine the move, fadeout, and remove
        let actions = SKAction.sequence([groupAction, removeAction])
        
        skeleton.run(actions, completion: playWalkthrough)
        
    }
    
    func getMiddleBoxAction(box: SKSpriteNode) -> SKAction {
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: timeToShuffle)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: timeToShuffle)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
    }
    
    
    func getLeftBoxAction(box: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
        
        let startPoint = CGPoint(x: 300, y: 200)
        let endPoint = CGPoint(x: 700, y: 200)
        
        let control1 = CGPoint(x: 500, y: 400)
        let control2 = CGPoint(x: 700, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: timeToShuffle)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 700, y: 200)
        let endPoint2 = CGPoint(x: 300, y: 199)
        
        let control3 = CGPoint(x: 500, y: 0)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 301, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: timeToShuffle)
        
        let sequence = SKAction.sequence([curve, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
        
    }
    
    func getRightBoxAction(box: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
        
        let startPoint = CGPoint(x: 699, y: 200)
        let endPoint = CGPoint(x: 300, y: 200)
        
        let control1 = CGPoint(x: 500, y: 0)
        let control2 = CGPoint(x: 300, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: timeToShuffle)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 300, y: 200)
        let endPoint2 = CGPoint(x: 700, y: 200)
        
        let control3 = CGPoint(x: 500, y: 420)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 699, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: timeToShuffle)
        
        let sequence = SKAction.sequence([curve, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
        
    }
}
