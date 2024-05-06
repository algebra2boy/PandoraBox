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
    
    var repeatedCount: Int = Int.random(in: 1...3)
    
    var timeToShuffle: TimeInterval = TimeInterval(Float.random(in: 0.3...0.8))
    
    @Binding var isGameStarted: Bool
    
    @Binding var isAnimating: Bool
    
    @Binding var winCount: Int
    
    @Binding var lostCount: Int
    
    init(_ isGameStarted: Binding<Bool>, _ isAnimating: Binding<Bool>, _ winCount: Binding<Int>, _ lostCount: Binding<Int>) {
        _isGameStarted = isGameStarted
        _isAnimating = isAnimating
        _winCount = winCount
        _lostCount = lostCount
        super.init(size: CGSize(width: 1000, height: 600))
        self.scaleMode = .aspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        _isGameStarted = .constant(false)
        _isAnimating = .constant(false)
        _winCount = .constant(0)
        _lostCount = .constant(0)
        super.init(coder: aDecoder)
    }
    
}
