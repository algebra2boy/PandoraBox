//
//  PandoraGame+Logic.swift
//  CupGame
//
//  Created by Yongye on 5/6/24.
//

import SpriteKit

extension PandoraGameScene {
    
    func setupBoxes(imageName: String = "boxOpen") {
        
        // the cup positions in the x and y coordinate
        let boxPositions = [
            CGPoint(x: 300, y: 200),
            CGPoint(x: 500, y: 200),
            CGPoint(x: 700, y: 200)
        ]
        
        // adding the cup to each position on the scene
        for position in boxPositions {
            let box = SKSpriteNode(imageNamed: imageName)
            box.size = CGSize(width: 200, height: 200)
            box.position = position
            addChild(box)
            boxes.append(box)
        }
        
    }
    
    // load the ghost image from the assets
    func loadSkletonTextures() -> [SKTexture] {
        var textures: [SKTexture] = []
        
        for i in 1...3 {
            let imageName = "ghost\(i)"
            textures.append(SKTexture(imageNamed: imageName))
        }
        
        return textures
    }
    
    func createAnimationAction() -> SKAction {
        let textures = loadSkletonTextures()
        
        // load the new ghost texture for every 0.15
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.15)
        
        // make it run forever
        let forever = SKAction.repeatForever(animationAction)
        
        return forever
    }
    
    
    func addSkletonAboveBox() {
        
        // the skeleton will be at either at index 0, or 1, or 2
        skeletonPosition = Int.random(in: 0 ..< boxes.count)
        
        // the ball position will be underneath the cup
        let x = boxes[skeletonPosition].position.x
        let y = boxes[skeletonPosition].position.y + 130
        
        skeleton.position = CGPoint(x: x, y: y)
        skeleton.size = CGSize(width: 150, height: 150)
        
        addChild(skeleton)
        
        let animationAction = createAnimationAction()
        skeleton.run(animationAction)
    }
    
    func clean() {
        for box in boxes {
            box.removeFromParent()
        }
        skeleton.removeFromParent()
        
        boxes = []
        skeleton = SKSpriteNode()
        
    }
    
    
    func addSkletonInsideBox() {
        
        // the skeleton will be at either at index 0, or 1, or 2
        skeletonPosition = Int.random(in: 0 ..< boxes.count)
        
        // the skeleton will be inside the box
        let x = boxes[skeletonPosition].position.x
        let y = boxes[skeletonPosition].position.y
        
        skeleton.position = CGPoint(x: x, y: y)
        skeleton.size = CGSize(width: 150, height: 150)
        
        addChild(skeleton)
        
        let animationAction = createAnimationAction()
        skeleton.run(animationAction)
    }
    
}


extension PandoraGameScene {
    
    func initalizeGame() {
        backgroundColor = .white
        setupBoxes()
        addSkletonAboveBox()
    }
        
    func removeBoxesAndSkeleton() {
        
        // remove the open boxes and skeleton
        clean()
        
        // switch the image from open to close
        setupBoxes(imageName: "boxClose")
        
    }
    
    func playWalkthrough() {
        
        removeBoxesAndSkeleton()
        
        let wait = SKAction.wait(forDuration: 2)
        
        let shuffleAction = SKAction.run(shuffleBoxes)
        
        let sequence = SKAction.sequence([wait, shuffleAction])
        
        self.run(sequence)
        
        skeletonPosition = Int.random(in: 0 ..< boxes.count)
        repeatedCount = Int.random(in: 1...3)
        timeToShuffle = TimeInterval(Float.random(in: 0.3...0.8))
    }
    
    func revealBoxes(_ boxPosition: Int) {
        
        // remove the open boxes and skeleton
        clean()
        
        // set up open boxes
        setupBoxes()
        
        addSkletonInsideBox()
        
        makeSkeletonAppear()
        
        checkWin(boxPosition)
        
    }
    
    func checkWin(_ boxPosition: Int) {
        
        if (boxPosition == self.skeletonPosition) {
            lostCount += 1
        } else {
            winCount += 1
        }
    }
    
    func shuffleBoxes() {
        
        guard boxes.count >= 3 else { return }
        
        let leftBox = boxes[0]
        let middleBox = boxes[1]
        let rightBox = boxes[2]
        
        let nodes = [boxes[0], boxes[1], boxes[2]]
        
        let group = [
            getLeftBoxAction(box: leftBox),
            getMiddleBoxAction(box: middleBox),
            getRightBoxAction(box: rightBox)
        ]
        
        var completedAction = 0
        let totalAction = nodes.count
        
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
