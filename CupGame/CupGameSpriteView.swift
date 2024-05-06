//
//  PandoraGameSceneSpriteView.swift
//  CupGame
//
//  Created by Yongye Tan on 5/1/24.
//

import SwiftUI
import SpriteKit

class PandoraGameScene: SKScene {
    
    private var boxes: [SKSpriteNode] = []
    private var skeleton = SKSpriteNode()
    
    private var skeletonPosition: Int = 1 // zero based
    
    let repeatedCount: Int = 1
    
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
                    revealBoxes(index, skeletonPosition)
                }
                
            }
            
        }
    }
    
}

extension PandoraGameScene {
    
    func initalizeGame() {
        backgroundColor = .white
        setupBoxes()
        addSkletonAboveBox()
    }
    
    func makeSkeletonDisappear() {
        
        // create a move action
        let actionMoveDown = SKAction.moveBy(x: 0, y: -100, duration: 0.5)
        
        // create a fade out action so the ghost seems like disappearing
        let actionFadeOut = SKAction.fadeOut(withDuration: 1)
        
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
        let actionFadeOut = SKAction.fadeOut(withDuration: 1)
        
        // combine the move and fade out actions
        let groupAction = SKAction.group([actionMoveUp, actionFadeOut])
        
        // remove the skeleton from the scene
        let removeAction = SKAction.removeFromParent()
        
        // combine the move, fadeout, and remove
        let actions = SKAction.sequence([groupAction, removeAction])
        
        skeleton.run(actions, completion: playWalkthrough)
        
    }
    
    func removeBoxesAndSkeleton() {
        
        // remove the open boxes and skeleton
        clean()
        
        // switch the image from open to close
        setupBoxes(imageName: "boxClose")
        
    }
    
    func playWalkthrough() {
        
        self.isAnimating = true
        
        removeBoxesAndSkeleton()
        
        let wait = SKAction.wait(forDuration: 2)
        
        let shuffleAction = SKAction.run(shuffleBoxes)
        
        let sequence = SKAction.sequence([wait, shuffleAction])
        
        self.run(sequence)
        
        skeletonPosition = Int.random(in: 0 ..< boxes.count)
    }
    
    func revealBoxes(_ boxPosition: Int, _ skeletonPosition: Int) {
        
        checkWin(boxPosition, skeletonPosition)
        
        // remove the open boxes and skeleton
        clean()
        
        // set up open boxes
        setupBoxes()
        
        addSkletonInsideBox()
        
        makeSkeletonAppear()
        
        
    }
    
    func checkWin(_ boxPosition: Int, _ skeletonPosition: Int) {
        print("boxPosition \(boxPosition)")
        print("skeletonPosition \(skeletonPosition)")
        if (boxPosition == skeletonPosition) {
            winCount += 1
        } else {
            lostCount += 1
        }
    }
    
    func shuffleBoxes() {
        
        guard boxes.count >= 3 else { return }
        
        let leftBox = boxes[0]
        let middleBox = boxes[1]
        let rightBox = boxes[2]
        
        let nodes = [boxes[0], boxes[1], boxes[2]]
        
        let group = [
            getLeftCupAction(box: leftBox),
            getMiddleCupAction(box: middleBox),
            getRightCupAction(box: rightBox)
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
    
    func getMiddleCupAction(box: SKSpriteNode) -> SKAction {
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
    }
    
    
    func getLeftCupAction(box: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
        
        let startPoint = CGPoint(x: 300, y: 200)
        let endPoint = CGPoint(x: 700, y: 200)
        
        let control1 = CGPoint(x: 500, y: 400)
        let control2 = CGPoint(x: 700, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 700, y: 200)
        let endPoint2 = CGPoint(x: 300, y: 199)
        
        let control3 = CGPoint(x: 500, y: 0)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 301, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
        
    }
    
    func getRightCupAction(box: SKSpriteNode) -> SKAction {
        
        let path = CGMutablePath()
        
        let startPoint = CGPoint(x: 699, y: 200)
        let endPoint = CGPoint(x: 300, y: 200)
        
        let control1 = CGPoint(x: 500, y: 0)
        let control2 = CGPoint(x: 300, y: 200)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: control1, control2: control2)
        
        let curve = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 1)
        
        let path2 = CGMutablePath()
        let startPoint2 = CGPoint(x: 300, y: 200)
        let endPoint2 = CGPoint(x: 700, y: 200)
        
        let control3 = CGPoint(x: 500, y: 420)
        
        // the last control cannot be the exact point as endpoint 2
        // otherwise it causes endpoint discrepancies
        let control4 = CGPoint(x: 699, y: 199)
        
        path2.move(to: startPoint2)
        path2.addCurve(to: endPoint2, control1: control3, control2: control4)
        
        let curve2 = SKAction.follow(path2, asOffset: false, orientToPath: false, duration: 1)
        
        let sequence = SKAction.sequence([curve, curve2])
        let repeated_seq = SKAction.repeat(sequence, count: repeatedCount)
        
        return repeated_seq
        
    }
}

struct PandoraGameSpriteView: View {
    
    @State private var isGameStarted: Bool = false
    
    @State private var isAnimating: Bool = false
    
    @State private var winCount: Int = 0
    
    @State private var lostCont: Int = 0
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            SpriteView(scene: PandoraGameScene($isGameStarted, $isAnimating, $winCount, $lostCont))
                .frame(width: 1000, height: 600)
                .ignoresSafeArea()
            
            Text(isGameStarted ? "Pick one box" : "Tap on screen..")
                .font(.system(size: 30))
                .font(.footnote)
            
            VStack {
                HStack {
                    Text("# of Win \(winCount)")
                }
                
                HStack {
                    Text("# of Lost \(lostCont)")
                }
            }
            .font(.system(size: 40))
            .font(.headline)
            
        }
    }
}

#Preview {
    PandoraGameSpriteView()
}
