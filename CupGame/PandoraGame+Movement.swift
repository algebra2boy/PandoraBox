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
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: timeToShuffle / 2)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: timeToShuffle / 2)
        let moveLeft = SKAction.moveBy(x: 200, y: 0, duration: timeToShuffle / 2)
        let moveRight = SKAction.moveBy(x: -200, y: 0, duration: timeToShuffle / 2)
        
        let horizotal_seq = SKAction.sequence([moveRight, moveLeft, moveLeft, moveRight])
        let vertical_seq = SKAction.sequence([moveUp, moveDown])
        
        let seq = SKAction.sequence([horizotal_seq, vertical_seq])
        
        let repeated_seq = SKAction.repeat(seq, count: 1)
        
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
        
        let startPoint1 = CGPoint(x: 300, y: 300)
        let endPoint1 = CGPoint(x: 700, y: 300)
        let control1 = CGPoint(x: 500, y: 500)
        let control2 = CGPoint(x: 700, y: 300)
        
        
        let curve1 = produceCurve(
            startPoint: startPoint1,
            endPoint: endPoint1,
            control1: control1,
            control2: control2
        )
        
        let startPoint2 = CGPoint(x: 700, y: 300)
        let endPoint2 = CGPoint(x: 300, y: 299)
        
        // the last control cannot be the exact point as endpoint 2 otherwise it causes endpoint discrepancies
        let control3 = CGPoint(x: 500, y: 0)
        let control4 = CGPoint(x: 301, y: 299)
        
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
        
        let startPoint1 = CGPoint(x: 699, y: 300)
        let endPoint1 = CGPoint(x: 300, y: 300)
        let control1 = CGPoint(x: 500, y: 0)
        let control2 = CGPoint(x: 300, y: 300)
        
        let curve1 = produceCurve(
            startPoint: startPoint1,
            endPoint: endPoint1,
            control1: control1,
            control2: control2
        )
        
        let startPoint2 = CGPoint(x: 300, y: 300)
        let endPoint2 = CGPoint(x: 700, y: 300)
        let control3 = CGPoint(x: 500, y: 520)
        let control4 = CGPoint(x: 699, y: 299)
        
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
