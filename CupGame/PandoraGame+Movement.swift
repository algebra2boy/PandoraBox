//
//  PandoraGame+Movement.swift
//  CupGame
//
//  Created by Yongye on 5/6/24.
//

import SpriteKit

extension PandoraGameScene {
    
    enum SkeletonMovement {
        case up, down
    }
    
    /// move Skeleton above the box or inside the box
    /// - Parameters:
    ///     - movement: `up` means skeleton goes from inside the box to above, `down` means goes from above to inside the box
    func moveSkeleton(_ movement: SkeletonMovement) {
        
        var moveAction: SKAction
        
        // create a move action
        switch movement {
        case .up: moveAction = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
        case .down: moveAction = SKAction.moveBy(x: 0, y: -100, duration: 0.5)
        }
        
        // create a fade out action so the ghost seems like disappearing
        let fadeOutAction = SKAction.fadeOut(withDuration: 2)
        
        // combine the move and fade out actions
        let groupAction = SKAction.group([moveAction, fadeOutAction])
        
        // remove the skeleton from the scene
        let removeAction = SKAction.removeFromParent()
        
        // combine the move, fadeout, and remove
        let actions = SKAction.sequence([groupAction, removeAction])
        
        skeleton.run(actions, completion: playWalkthrough)
    }
    
    /// generate action to move the middle box
    /// - Returns: `SKAction` that controls the box movement
    func getMiddleBoxAction() -> SKAction {
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: timeToShuffle)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: timeToShuffle)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
    }
    
    /// helper function to produce a curve with startPoint, endPoint, first contorl and second control
    func produceCurve(startPoint: CGPoint, endPoint: CGPoint, control1: CGPoint, control2: CGPoint) -> SKAction {
        
        let path = CGMutablePath()
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: timeToShuffle)
        
        return curve
        
    }
    
    func getLeftBoxAction() -> SKAction {
        
        let startPoint = CGPoint(x: 300, y: 200)
        let endPoint = CGPoint(x: 700, y: 200)
        let control1 = CGPoint(x: 500, y: 400)
        let control2 = CGPoint(x: 700, y: 200)
        
        
        let curve1 = produceCurve(
            startPoint: startPoint,
            endPoint: endPoint,
            control1: control1,
            control2: control2
        )
        
        let startPoint2 = CGPoint(x: 700, y: 200)
        let endPoint2 = CGPoint(x: 300, y: 199)
        
        // the last control cannot be the exact point as endpoint 2 otherwise it causes endpoint discrepancies
        let control3 = CGPoint(x: 500, y: 0)
        let control4 = CGPoint(x: 301, y: 199)
        
        let curve2 = produceCurve(
            startPoint: startPoint2,
            endPoint: endPoint2,
            control1: control3,
            control2: control4
        )
        
        let sequence = SKAction.sequence([curve1, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
        
    }
    
    func getRightBoxAction() -> SKAction {
        
        let startPoint = CGPoint(x: 699, y: 200)
        let endPoint = CGPoint(x: 300, y: 200)
        let control1 = CGPoint(x: 500, y: 0)
        let control2 = CGPoint(x: 300, y: 200)
        
        let curve1 = produceCurve(
            startPoint: startPoint,
            endPoint: endPoint,
            control1: control1,
            control2: control2
        )
        
        let startPoint2 = CGPoint(x: 300, y: 200)
        let endPoint2 = CGPoint(x: 700, y: 200)
        let control3 = CGPoint(x: 500, y: 420)
        let control4 = CGPoint(x: 699, y: 199)
        
        let curve2 = produceCurve(
            startPoint: startPoint2,
            endPoint: endPoint2,
            control1: control3,
            control2: control4)
        
        let sequence = SKAction.sequence([curve1, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
        
    }
}
