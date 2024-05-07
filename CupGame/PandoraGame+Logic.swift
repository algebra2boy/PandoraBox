//
//  PandoraGame+Logic.swift
//  CupGame
//
//  Created by Yongye on 5/6/24.
//

import SpriteKit

extension PandoraGameScene {
    
    enum BoxImageName: String {
        case boxOpen = "boxOpen"
        case boxClose = "boxClose"
    }
    
    /// Sets the boxes with `SKSpriteNode`
    /// - Parameters:
    ///   - imageName: The image name of the box, either "boxOpen" or "boxClose"
    func setupBoxes(imageName: BoxImageName) {
        
        // the box positions in the x and y coordinate
        let boxPositions = [
            CGPoint(x: 300, y: 200),
            CGPoint(x: 500, y: 200),
            CGPoint(x: 700, y: 200)
        ]
        
        // adding the box to each position on the scene
        for position in boxPositions {
            let box = SKSpriteNode(imageNamed: imageName.rawValue)
            box.size = CGSize(width: 200, height: 200)
            box.position = position
            addChild(box)
            boxes.append(box)
        }
        
    }
    
    func removeBoxesAndSkeleton() {
        for box in boxes {
            box.removeFromParent()
        }
        skeleton.removeFromParent()
        
        boxes = []
        skeleton = SKSpriteNode()
        
    }
    
}

// Handles rendering skeleton
extension PandoraGameScene {
    
    enum SkeletonPlacement {
        case aboveBox
        case insideBox
    }
    
    /// load texture for the skeleton for render
    /// - Returns: An array of `SKTexture`
    func loadSkeletonTexture() -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for i in 1...3 {
            let imageName = "ghost\(i)"
            textures.append(SKTexture(imageNamed: imageName))
        }
        
        return textures
    }
    
    /// generate action for the skeleton texture to run forever
    /// - Returns: A `SKAction`
    func createAnimationAction() -> SKAction {
        let textures = loadSkeletonTexture()
        
        // animate the new ghost texture for every 0.15
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.15)
        
        // make it run forever
        let foreverAction = SKAction.repeatForever(animationAction)
        
        return foreverAction
    }
    
    /// Add skeleton either above the box or inside the box
    /// - Parameters:
    ///   - placement: The placement of skeleton, either `aboveBox` or `insideBox`
    func addSkeleton(at placement: SkeletonPlacement) {
        
        // the skeleton will be at either at index 0, or 1, or 2
        skeletonPosition = Int.random(in: 0 ..< boxes.count)
        
        let x = boxes[skeletonPosition].position.x
        var y = boxes[skeletonPosition].position.y
        
        switch placement {
        case .aboveBox: y += 130
        case .insideBox: y += 0
        }
        
        skeleton.position = CGPoint(x: x, y: y)
        skeleton.size = CGSize(width: 150, height: 150)
        
        addChild(skeleton)
        
        let animationAction = createAnimationAction()
        skeleton.run(animationAction)
        
    }
}


extension PandoraGameScene {
    
    func setupBackground() {
        
        let background = SKSpriteNode(imageNamed: "background")
        
        // position the background in the middle of the scene
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        // set the size of the background to fill the entire scene
        background.size = self.size
        
        // stay behind all the nodes
        background.zPosition = -1

        addChild(background)
        
    }
    
    func initalizeGame() {
        setupBackground()
        setupBoxes(imageName: .boxOpen)
        addSkeleton(at: .aboveBox)
    }
        
    func playWalkthrough() {
        
        self.isAnimating = true
        
        removeBoxesAndSkeleton()
        
        setupBoxes(imageName: .boxClose)
        
        let waitAction = SKAction.wait(forDuration: 2)
        
        let shuffleAction = SKAction.run(shuffleBoxes)
        
        let sequence = SKAction.sequence([waitAction, shuffleAction])
        
        self.run(sequence)
        
        // re-generate for a new game
        skeletonPosition = Int.random(in: 0 ..< boxes.count)
        repeatedCount = Int.random(in: 1...3)
        timeToShuffle = TimeInterval(Float.random(in: 0.3...0.8))
    }
    
    func revealBoxes(at boxPosition: Int) {
        
        // These functions needed to be run using SKAction because they involve manipulating SpriteNode
        let animatingAction = SKAction.run { self.isAnimating = true }
        
        let removeAction = SKAction.run(self.removeBoxesAndSkeleton)
        
        let setupAction = SKAction.run { self.setupBoxes(imageName: .boxOpen) }
        
        let addSkeletonAction = SKAction.run { self.addSkeleton(at: .insideBox) }
        
        let moveSkeletonAction = SKAction.run { self.moveSkeleton(.up) }
        
        let sequence = SKAction.sequence([animatingAction, removeAction, setupAction, addSkeletonAction, moveSkeletonAction])
        
        self.run(sequence)
        
        checkWin(with: boxPosition)
        
    }
    
    func checkWin(with boxPosition: Int) {
        
        if (boxPosition == self.skeletonPosition) {
            lostCount += 1
        } else {
            winCount += 1
        }
    }
    
    func shuffleBoxes() {
        
        guard boxes.count >= 3 else { return }
        
        let nodes = [boxes[0], boxes[1], boxes[2]]
        
        let group = [
            getLeftBoxAction(),
            getMiddleBoxAction(),
            getRightBoxAction()
        ]
        
        var completedAction = 0
        let totalAction = nodes.count
        
        // loop over each action and run each action using corresponding node
        for (index, node) in nodes.enumerated() {
            node.run(group[index]) {
                
                completedAction += 1
                
                if completedAction == totalAction {
                    self.isAnimating = false
                }
            }
        }
        
    }
    
}
