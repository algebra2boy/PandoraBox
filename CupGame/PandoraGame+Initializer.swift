//
//  PandoraGameScene.swift
//  CupGame
//
//  Created by Yongye on 5/6/24.
//

import SwiftUI
import SpriteKit

class PandoraGameScene: SKScene {
    
    var boxes: [SKSpriteNode] = []
    var skeleton = SKSpriteNode()
    
    var skeletonPosition: Int = 1 // zero based
    
    var repeatedCount: Int = Int.random(in: 1...4)
    
    var timeToShuffle: TimeInterval = TimeInterval(Float.random(in: 0.5...1.2))
    
    @Binding var isGameStarted: Bool
    
    @Binding var isAnimating: Bool
    
    @Binding var isSkeletonPicked: Bool
        
    init(_ isGameStarted: Binding<Bool>, _ isAnimating: Binding<Bool>, _ isSkeletonPicked: Binding<Bool> ) {
        _isGameStarted = isGameStarted
        _isAnimating = isAnimating
        _isSkeletonPicked = isSkeletonPicked
        super.init(size: CGSize(width: 1000, height: 600))
        self.scaleMode = .aspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        _isGameStarted = .constant(false)
        _isAnimating = .constant(false)
        _isSkeletonPicked = .constant(false)
        super.init(coder: aDecoder)
    }
    
}
